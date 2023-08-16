
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

module "cluster_group_gitops" {
  source = "./clustergroups/dev/"
}

module "iris_dev_cluster" {
  source = "./clustergroups/dev/iris-dev/"
  depends_on = [ module.cluster_group_gitops ]
  
  cluster_name = "iris-dev"
  tmc-api-key = data.azurerm_key_vault_secret.tmc-api-key.value
  tmc-endpoint = data.azurerm_key_vault_secret.tmc-endpoint.value
  azure-client-id = data.azurerm_key_vault_secret.akv-client-id.value
  azure-client-secret = data.azurerm_key_vault_secret.akv-client-secret.value
}


############ Dev2 cluster #################
module "iris_dev2_cluster" {
  source = "./clustergroups/dev/iris-dev2/"
  depends_on = [ module.cluster_group_gitops ]
  
  cluster_name = "iris-dev2"
  tmc-api-key = data.azurerm_key_vault_secret.tmc-api-key.value
  tmc-endpoint = data.azurerm_key_vault_secret.tmc-endpoint.value
  azure-client-id = data.azurerm_key_vault_secret.akv-client-id.value
  azure-client-secret = data.azurerm_key_vault_secret.akv-client-secret.value
}



############ Dev2 cluster #################

