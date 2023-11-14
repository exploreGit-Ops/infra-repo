
# module "iris-test-cluster" {
#   source = "../../../modules/tmc_aks_cluster"
#   cluster_name = "iris-test"
#   cluster_group = "test"
#   resource_group = "my-resource-grp-sp"
#   subscription_id = "d37d2a44-e6cc-434c-9e82-190ab5a1edf4"
#   credential_name = "sp-aks-creds"
#   region = "westus2"
#   k8s_version = "1.25.11"
# }

# module "infra-ops_bootstrap" {
#   source = "../../../modules/cluster_bootstrap/"
#   kubeconfig = module.iris-test-cluster.kubeconfig
#   azure_client_id = var.azure-client-id
#   azure_client_secret = var.azure-client-secret
#   cluster_name = module.iris-test-cluster.cluster_name
# }