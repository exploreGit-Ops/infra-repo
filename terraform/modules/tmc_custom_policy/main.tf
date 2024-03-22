
resource "tanzu-mission-control_custom_policy" "custom" {
  name = var.policy_name

  scope {
    cluster_group {
      cluster_group = var.cluster_group
    }
  }


  spec {
    input {
      custom {
        template_name = var.template_name
        audit         = var.audit


        parameters = var.parameters != null ? jsonencode(var.parameters) : null

        dynamic "target_kubernetes_resources" {
          for_each = var.target_kubernetes_resources
          content {
            api_groups = target_kubernetes_resources.value["api_groups"]
            kinds = target_kubernetes_resources.value["kinds"]
          }
        }

      }
    }

    namespace_selector {
      dynamic "match_expressions" {
          for_each = var.match_expressions
          content {
            key      = match_expressions.value["key"]
            operator = match_expressions.value["operator"]
            values = match_expressions.value["values"]
          }
        }
    }
  }
}