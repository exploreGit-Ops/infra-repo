
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
  key_vault_id = data.azurerm_key_vault.epxlore-gitops.id
}

module "cluster_group_gitops" {
  source = "./clustergroups/dev/"
}

module "cluster_create" {
  source = "./clustergroups/dev/iris-dev/"
  depends_on = [ module.cluster_group_gitops ]
}
