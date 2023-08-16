module "enforce-sa-policy-template" {
  source = "../modules/tmc_custom_policy_template"
  template-file = abspath("${path.module}/templates/enforce-es-naming-template.yaml")
  data-inventory = "/v1/Namespace"
}