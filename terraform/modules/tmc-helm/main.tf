# Create Tanzu Mission Control cluster group scope helm feature with attached set as default value.
resource "tanzu-mission-control_helm_feature" "create_cg_helm_feature" {
  scope {
    cluster_group {
      name = var.cluster_group # Required
    }
  }
}