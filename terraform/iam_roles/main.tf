
module "cluster-admin-equiv" {
  source = "../modules/iam_role"
  policy-file = abspath("${path.module}/roles/cluster-admin-equiv-iam.yaml")

}


module "metatmc-controller-role" {
  source = "../modules/iam_role"
  policy-file = abspath("${path.module}/roles/tmcnamespaces-iam.yaml")

}

