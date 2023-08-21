terraform {
   backend "azurerm" {}
  required_providers {

    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.68.0"
    }
    # tanzu-mission-control = {
    #   source  = "vmware/tanzu-mission-control"
    #   version = "1.2.1"
    # }
     tanzu-mission-control = {
      source  = "terraform.local/local/tmc"
      version = "1.0.0"
    }
    }
  }
provider "azurerm" {
  features {}
}
provider "tanzu-mission-control" {
  # Configuration options
  endpoint            = local.tmc-endpoint            # optionally use TMC_ENDPOINT env var
  vmw_cloud_api_token = local.tmc-api-key # optionally use VMW_CLOUD_API_TOKEN env var

  # if you are using dev or different csp endpoint, change the default value below
  # for production environments the vmw_cloud_endpoint is console.cloud.vmware.com
  # vmw_cloud_endpoint = "console.cloud.vmware.com" or optionally use VMW_CLOUD_ENDPOINT env var
}

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