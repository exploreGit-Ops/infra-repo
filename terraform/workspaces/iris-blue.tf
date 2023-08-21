resource "tanzu-mission-control_workspace" "create_workspace" {
  name = "iris-blue"

  meta {
    description = "Create workspace through terraform"
    labels = {
      "mode" : "automation",
      "platform" : "terraform-test"
    }
  }
}

/*
 Workspace scoped Tanzu Mission Control IAM policy.
 This resource is applied on a workspace to provision the role bindings on the associated workspace.
 The defined scope block can be updated to change the access policy's scope.
 */
resource "tanzu-mission-control_iam_policy" "iris-blue-cluster-admin-policy" {
  scope {
    workspace {
      name = tanzu-mission-control_workspace.create_workspace.name
    }
  }

  role_bindings {
    role = "cluster-admin-equiv"
    subjects {
      name = "iris-blue:tenant-flux-reconciles"
      kind = "K8S_SERVICEACCOUNT"
    }
  }
}