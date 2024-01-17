
module "infra-ops-cluster" {
  source = "../../../modules/tmc_eks_cluster"
  cluster_name = "infra-ops"
  subnet_ids = [
    "subnet-1c116c57",
    "subnet-efa6eac7",
    "subnet-55a1f12c",
    "subnet-6594b73f"
  ]
  np_subnet_ids = [ 
    "subnet-1c116c57",
    "subnet-efa6eac7",
    "subnet-55a1f12c",
    "subnet-6594b73f"
  ]
  region = "us-west-2"
  eks_credential = "eks-warroyo2"
  k8s_version = "1.28"
  cluster_group = "infra-ops"
}

module "infra-ops_bootstrap" {
  source = "../../../modules/cluster_bootstrap/"
  kubeconfig = module.infra-ops-cluster.kubeconfig
  azure_client_id = var.azure-client-id
  azure_client_secret = var.azure-client-secret
  cluster_name = module.infra-ops-cluster.cluster_name
}