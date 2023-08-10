resource "tanzu-mission-control_workspace" "create_workspace" {
  name = "iris-dev"

  meta {
    description = "Create workspace through terraform"
    labels = {
      "mode" : "automation",
      "platform" : "mutli_cloud"
    }
  }
}

/*
 Workspace scoped Tanzu Mission Control IAM policy.
 This resource is applied on a workspace to provision the role bindings on the associated workspace.
 The defined scope block can be updated to change the access policy's scope.
 */
resource "tanzu-mission-control_iam_policy" "workspace_scoped_iam_policy" {
  scope {
    workspace {
      name = "iris-dev"
    }
  }

  role_bindings {
    role = "workspace.edit"
    subjects {
      name = "developer"
      kind = "USER"
    }
  }
}