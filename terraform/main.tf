
data "azurerm_key_vault" "explore-gitops" {
  name                = "explore-gitops"
  resource_group_name = "keyvaults"
}
data "azurerm_key_vault_secret" "tmc-endpoint" {
  name         = "tmc-endpoint"
  key_vault_id = data.azurerm_key_vault.explore-gitops.id
}

data "azurerm_key_vault_secret" "tmc-api-key" {
  name         = "tmc-api-key"
  key_vault_id = data.azurerm_key_vault.explore-gitops.id
}

data "azurerm_key_vault_secret" "akv-client-id" {
  name         = "akv-client-id"
  key_vault_id = data.azurerm_key_vault.explore-gitops.id
}

data "azurerm_key_vault_secret" "akv-client-secret" {
  name         = "akv-client-secret"
  key_vault_id = data.azurerm_key_vault.explore-gitops.id
}

## this sets up our TMC context becuase we can't assume it exists
data "shell_script" "create-context" {
    sensitive_environment = {
    TANZU_API_TOKEN = data.azurerm_key_vault_secret.tmc-api-key.value
   }
    lifecycle_commands {
        read = <<-EOF
          set -e
          context=$(tanzu context list -t tmc -o json | jq 'map(select(.name == "tmc-tf"))')
          if [[ "$context" != "[]" ]]; then
            tanzu context delete tmc-tf  -y
          fi
          tanzu context create tmc-tf --endpoint ${data.azurerm_key_vault_secret.tmc-endpoint.value}
          echo "{}"
        EOF
        
    }
}

module "iam_roles" {

source = "./iam_roles"

}

module "policy_templates" {

source = "./policy_templates"

}

#------------------dev-----------------------------

module "cluster_group_dev" {
  source = "./clustergroups/dev/"
  depends_on = [ module.policy_templates ]
}


module "cluster_group_dev_clusters" {
  source = "./clustergroups/dev/clusters/"
  depends_on = [ module.cluster_group_dev ]
  
  azure-client-id = data.azurerm_key_vault_secret.akv-client-id.value
  azure-client-secret = data.azurerm_key_vault_secret.akv-client-secret.value
}

#------------------infra-ops-----------------------------

module "cluster_group_infra-ops" {
  source = "./clustergroups/infra-ops/"
  depends_on = [ module.policy_templates ]
}

module "cluster_group_infra-ops_clusters" {
  source = "./clustergroups/infra-ops/clusters/"
  depends_on = [ module.cluster_group_infra-ops ]
  
  azure-client-id = data.azurerm_key_vault_secret.akv-client-id.value
  azure-client-secret = data.azurerm_key_vault_secret.akv-client-secret.value
}
