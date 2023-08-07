# Create Tanzu Mission Control kustomization with attached set as default value.
resource "tanzu-mission-control_kustomization" "create_cluster_group_kustomization" {
  name = "tf-kustomization" # Required

  namespace_name = "tanzu-continuousdelivery-resources" #Required

  scope {
    cluster_group {
      name = "dev" # Required
    }
  }

  meta {
    description = "Create kustomization through terraform"
    labels      = { "key" : "value" }
  }

    spec {
    path = "/" # Required
    prune = true
    interval = "5m" # Default: 5m
    source {
        name = "infra-base" # Required
       namespace = "tanzu-continuousdelivery-resources" # Required
    }
  }

  depends_on = [tanzu-mission-control_cluster_group.create_cluster_group,tanzu-mission-control_git_repository.create_cluster_group_git_repository]


}
