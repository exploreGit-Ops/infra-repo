
# module "iris-test-cluster" {
#   source = "../../../modules/tmc_aks_cluster"
#   cluster_name = "iris-test"
#   cluster_group = "test"
# }

# module "infra-ops_bootstrap" {
#   source = "../../../modules/cluster_bootstrap/"
#   kubeconfig = module.iris-test-cluster.kubeconfig
#   azure_client_id = var.azure-client-id
#   azure_client_secret = var.azure-client-secret
#   cluster_name = module.iris-test-cluster.cluster_name
# }