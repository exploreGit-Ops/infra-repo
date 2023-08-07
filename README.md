# Infra Repo

This repo is a part of the [VMWare Explore talk]() on creating developer ready K8s clusters using TMC and GitOps. This repo holds all of the terraform, and infra level flux configurations.

## Pre-reqs

* install the [Terraform Task](https://marketplace.visualstudio.com/items?itemName=ms-devlabs.custom-terraform-tasks) in your ADO organization
* [create a service connection](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml#create-a-service-connection) for your azure subscription in ADO. This will be used in the azure pipelines yaml. 

## Create the Azure backend for Terraform

1. login

```bash
az login
```

2. setup env vars for the resources we will create.

```bash
export RESOURCE_GROUP_NAME='tfstate-explore'
export STORAGE_ACCOUNT_NAME="tfstate01explore"
export CONTAINER_NAME='tfstate'
```

3. create the resources
```bash
# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location eastus

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

```