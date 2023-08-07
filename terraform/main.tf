module "cluster_group_gitops" {
  source = "./clustergroups/dev/"
  required_providers
}

module "cluster_create" {
  source = "./clustergroups/dev/iris-dev/"
  depends_on = [ module.cluster_group_gitops ]
}
