module "cluster_group_gitops" {
  source = "clustergroups/cg_1/main.tf"
}

module "cluster_create" {
  source = "clustergroups/cg_1/cluster_1/main.tf"
  depends_on = [ module.cluster_group_gitops ]
}
