terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.8.0"
    }
    tanzu-mission-control = {
      source  = "vmware/tanzu-mission-control"
      version = "1.2.0"
    }
    }
  }
provider "aws" {
  region = "us-east-2"
}  

provider "tanzu-mission-control" {
  # Configuration options
  endpoint            = var.endpoint            # optionally use TMC_ENDPOINT env var
  vmw_cloud_api_token = var.vmw_cloud_api_token # optionally use VMW_CLOUD_API_TOKEN env var

  # if you are using dev or different csp endpoint, change the default value below
  # for production environments the vmw_cloud_endpoint is console.cloud.vmware.com
  # vmw_cloud_endpoint = "console.cloud.vmware.com" or optionally use VMW_CLOUD_ENDPOINT env var
}
