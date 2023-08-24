resource "local_file" "enforce-es-naming-policy-test" {
       content     = templatefile("${path.root}/policies/enforce-es-naming.tftpl",{
        cluster_group = tanzu-mission-control_cluster_group.create_cluster_group.name
    })
    filename = "${path.root}/policies/enforce-es-naming-test.yaml"
}

module "enforce-es-naming-policy-test" {
  source = "../../modules/tmc_custom_policy"
  policy-file = local_file.enforce-es-naming-policy-test.filename
  scope = "clustergroup"

}


resource "local_file" "enforce-sa-policy-test" {
       content     = templatefile("${path.root}/policies/enforce-sa.tftpl",{
        cluster_group = tanzu-mission-control_cluster_group.create_cluster_group.name
    })
    filename = "${path.root}/policies/enforce-sa-test.yaml"
}

module "enforce-sa-policy-test" {
  source = "../../modules/tmc_custom_policy"
  scope = "clustergroup"
  policy-file = local_file.enforce-sa-policy-test.filename

}

