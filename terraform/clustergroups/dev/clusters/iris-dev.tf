module "iris-dev-cluster" {
  source = "../../../modules/tmc_eks_cluster"
  cluster_name = "iris-dev"
  subnet_ids = [
    "subnet-0da4532cf7ceabcf2",
    "subnet-017deb270cb808857",
     "subnet-02c618d32cf78be79",
    "subnet-0b2346462a0831132"
  ]
  np_subnet_ids = [ 
    "subnet-0da4532cf7ceabcf2",
    "subnet-017deb270cb808857"
  ]
  region = "us-east-2"
  eks_credential = "sp-eks-new"
  cluster_group = "dev"
}

module "iris_dev_bootstrap" {
  source = "../../../modules/cluster_bootstrap/"
  kubeconfig = module.iris-dev-cluster.kubeconfig
  azure_client_id = var.azure-client-id
  azure_client_secret = var.azure-client-id
}