module "cluster_group_gitops" {
  source = "./clustergroups/cg_1/"
  required_providers
}

module "cluster_create" {
  source = "./clustergroups/cg_1/cluster_1/"
  depends_on = [ module.cluster_group_gitops ]
}
