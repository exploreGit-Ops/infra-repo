
resource "tanzu-mission-control_kubernetes_secret" "create_boostrap_secret" {
  name           = "azure-secret-sp"                # Required
  namespace_name = "external-secrets" # Required 

  scope {
    cluster_group {
      name                    = var.cluster_group # Required
    }
  }

  export = false # Default: false
  spec {
    opaque = {
      "ClientID" : var.azure_client_id
      "ClientSecret" : var.azure_client_secret
    }
  }
}