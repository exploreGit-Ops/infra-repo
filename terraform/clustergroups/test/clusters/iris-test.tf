
module "iris-test-cluster" {
  source = "../../../modules/tmc_aks_cluster"
  cluster_name = "iris-test"
  cluster_group = "test"
  resource_group = "tmc-clusters"
  subscription_id = "31f60aa7-0ea5-47af-85b2-27e792a36288"
  credential_name = "warroyo-aks"
  region = "westus2"
  k8s_version = "1.28.0"
}

module "infra-ops_bootstrap" {
  source = "../../../modules/cluster_bootstrap/"
  kubeconfig = module.iris-test-cluster.kubeconfig
  azure_client_id = var.azure-client-id
  azure_client_secret = var.azure-client-secret
  cluster_name = module.iris-test-cluster.cluster_name
}