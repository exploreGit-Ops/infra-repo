terraform {
   backend "azurerm" {}
  required_providers {

    shell = {
      source = "Ninlives/shell"
      version = "1.7.12"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.68.0"
    }
    tanzu-mission-control = {
      source  = "vmware/tanzu-mission-control"
      version = "1.4.1"
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
