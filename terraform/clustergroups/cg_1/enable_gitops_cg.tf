# Create Tanzu Mission Control git repository with attached set as default value.
resource "tanzu-mission-control_git_repository" "create_cluster_git_repository" {
  name = "tmc-cd-new" # Required

  namespace_name = "tanzu-continuousdelivery-resources" #Required

  scope {
    cluster {
      name            = "eks.sp-eks-new.us-east-2.sp-eks-east-2-tf" # Required
      provisioner_name        = "eks"    # Default: attached
      management_cluster_name = "eks"    # Default: attached
    }
  }

  meta {
    description = "Create namespace through terraform"
    labels      = { "key" : "value" }
  }

  spec {
    url = "https://github.com/skandpurohit/tmc-cd" # Required
    #secret_ref = "testSourceSecret"
    interval = "5m" # Default: 5m
    git_implementation = "GO_GIT" # Default: GO_GIT
    ref {
      branch = "master" 
    #   tag = "testTag"
    #   semver = "testSemver"
    #   commit = "testCommit"
    } 
  }

  depends_on = [tanzu-mission-control_ekscluster.tf_eks_cluster]

}