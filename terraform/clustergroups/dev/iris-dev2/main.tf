module "tf_eks_cluster" {
  source = "../../../modules/tmc_eks_cluster"
  cluster_name = var.cluster_name
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
  tmc-api-key = var.tmc-api-key
  tmc-endpoint = var.tmc-endpoint
}

module "iris_dev2_bootstrap" {
  source = "../../../modules/cluster_bootstrap/"
  kubeconfig = module.tf_eks_cluster.kubeconfig
  azure_client_id = var.azure-client-id
  azure_client_secret = var.azure-client-id
}