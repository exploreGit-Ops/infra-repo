
module "enforce-es-naming-policy-test" {
  source = "../../modules/tmc_custom_policy"
  cluster_group =  "dev"
  policy_name = "es-access-by-label"
  template_name = "esbeginswith"
  parameters = {
    label =  "tmc.cloud.vmware.com/workspace"
  }
  target_kubernetes_resources = [
    {
      api_groups = ["external-secrets.io"]
      kinds = ["ExternalSecret"]
    }
  ]

  match_expressions = [
    {
      key = "tmc.cloud.vmware.com/workspace"
      operator = "Exists"
    }
  ]

}

module "enforce-sa-policy-test" {
 source = "../../modules/tmc_custom_policy"
  cluster_group =  "dev"
  policy_name = "fluxenforcesa"
  template_name = "fluxenforcesa"

  target_kubernetes_resources = [
    {
      api_groups = ["kustomize.toolkit.fluxcd.io"]
      kinds = ["Kustomization"]
    },
    {
      api_groups = [" helm.toolkit.fluxcd.io"]
      kinds = ["HelmRelease"]
    }
  ]

  match_expressions = [
    {
      values = ["tanzu-continuousdelivery-resources"]
      key = "kubernetes.io/metadata.name"
      operator = "NotIn"
    }
  ]

}

