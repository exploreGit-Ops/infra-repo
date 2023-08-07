# Create Tanzu Mission Control kustomization with attached set as default value.
resource "tanzu-mission-control_kustomization" "create_cluster_kustomization" {
  name = "tf-kustomization" # Required

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
    path = "/" # Required
    prune = true
    interval = "5m" # Default: 5m
    source {
        name = "tmc-cd-new" # Required
       namespace = "tanzu-continuousdelivery-resources" # Required
    }
  }

  depends_on = [tanzu-mission-control_ekscluster.tf_eks_cluster, tanzu-mission-control_namespace.create_namespace, tanzu-mission-control_git_repository.create_cluster_git_repository]
}