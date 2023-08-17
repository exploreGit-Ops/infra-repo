resource "local_file" "enforce-es-naming-policy-dev" {
       content     = templatefile("${path.module}/policies/enforce-es-naming.tftpl",{
        cluster_group = "dev"
    })
    filename = "${path.module}/policies/enforce-es-naming-dev.yaml"
}

module "enforce-es-naming-policy-dev" {
  source = "../modules/tmc_custom_policy"
  policy-file = local_file.enforce-es-naming-policy-dev.filename
  scope = "clustergroup"

}


resource "local_file" "enforce-sa-policy-dev" {
       content     = templatefile("${path.module}/policies/enforce-sa.tftpl",{
        cluster_group = "dev"
    })
    filename = "${path.module}/policies/enforce-sa-dev.yaml"
}

module "enforce-sa-policy-dev" {
  source = "../modules/tmc_custom_policy"
  scope = "clustergroup"
  policy-file = local_file.enforce-sa-policy-dev.filename

}

