# Create Tanzu Mission Control git repository with attached set as default value.
resource "tanzu-mission-control_git_repository" "create_cluster_group_git_repository" {
  name = "infra-gitops" # Required

  namespace_name = "tanzu-continuousdelivery-resources" #Required

  scope {
    cluster_group {
      name = "infra-ops" #Required
    }
  }


  spec {
    url = "https://github.com/warroyo/flux-tmc-multitenant" # Required
    #secret_ref = "testSourceSecret"
    interval = "5m" # Default: 5m
    git_implementation = "GO_GIT" # Default: GO_GIT
    ref {
      branch = "main" 
    #   tag = "testTag"
    #   semver = "testSemver"
    #   commit = "testCommit"
    } 
  }

  depends_on = [tanzu-mission-control_cluster_group.create_cluster_group]
}
