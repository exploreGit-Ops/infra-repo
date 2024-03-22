
resource "tanzu-mission-control_custom_iam_role" "tmc_namespace_role" {
  name = "metatmc-controller-role"

  spec {
    is_deprecated = false

    allowed_scopes = [
      "CLUSTER"
    ]

    tanzu_permissions = []

    kubernetes_permissions {
      rule {
        resources  = ["tmcnamespaces"]
        verbs      = ["get", "list","watch","create","update","delete","patch"]
        api_groups = ["tmc.tanzufield.vmware.com"]
      }
    }
  }
}

resource "tanzu-mission-control_custom_iam_role" "cluster_admi_equiv" {
  name = "cluster-admin-equiv"

  spec {
    is_deprecated = false

    allowed_scopes = [
      "NAMESPACE",
      "WORKSPACE"
    ]

    tanzu_permissions = [
      "cluster.namespace.get",
      "cluster.namespace.iam.get",
      "cluster.namespace.iam.set",
      "cluster.namespace.policy.get"
    ]

    kubernetes_permissions {
      rule {
        resources  = ["*"]
        verbs      = ["*"]
        api_groups = ["*"]
      }
      rule {
        url_paths  = ["/*"]
        verbs      = ["*"]
        api_groups = ["*"]
      }
    }
  }
}