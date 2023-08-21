# Infra Repo

This repo is a part of the [VMWare Explore talk](https://event.vmware.com/flow/vmware/explore2023lv/content/page/catalog?tab.contentcatalogtabs=1627421929827001vRXW&search=code2900LV) on creating developer ready K8s clusters using TMC and GitOps. This repo holds all of the terraform, and infra level flux configurations.

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

## Create the Azure Keyvault for Terraform secrets

We need a place to store secrets and retrieve them when using TF. for example the TMC API key.

1. create a resource group 

```bash 
az group create --name keyvaults --location eastus
```

2. create a keyvault

```bash
az keyvault create --name "explore-gitops" --resource-group "keyvaults" --location "EastUS"

```

3. get the SP that was created for your service connection in the pre-reqs. this can be found by looking at the service connection in ADO and clicking the link to "manage service prinipal" use that name to get the object ID

```bash
az ad sp list --display-name "service-connection-sp-name"
```

4. assign permissions to the sp on the keyvault


```bash
az role assignment create --role "Key Vault Secrets User" --assignee {object id from output above} --scope /subscriptions/{subscriptionid}/resourcegroups/keyvaults/providers/Microsoft.KeyVault/vaults/explore-gitops

```

## Create the initial secrets

We need secrets some initial secrets for bootstrapping the cluster prior to flux taking over.

### TMC credentials

These will be used for pulling the cluster kubeconfig and also any cli commands we need to run with TF that the provider doesn't currently support.

1. create the TMC secrets in the previously created vault

```bash
#the endpoint should just be the tmc hostname without the https://
az keyvault secret set --vault-name "explore-gitops" --name "tmc-endpoint" --value "<tmc-endpoint>"
az keyvault secret set --vault-name "explore-gitops" --name "tmc-api-key" --value "<tmc-api-key>"
```

2. create the azure client id and secret entries. these will be used to bootstrap the cluster so that external secrets can be used in the cluster. see [here](https://github.com/warroyo/flux-tmc-multitenant/blob/main/README.md#secret-tenancy) for more details about why we do this. This would be equivalent of the secret that is put into the `bootstrap/azure-secret.yaml`

```bash
az keyvault secret set --vault-name "explore-gitops" --name "akv-client-id" --value "<client-id>"
az keyvault secret set --vault-name "explore-gitops" --name "tmc-client-secret" --value "<client-secret>"
```
