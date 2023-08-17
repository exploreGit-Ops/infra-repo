
locals {
  role-name = yamldecode(file(var.policy-file)).fullName.name
}


resource "shell_script" "create_iam_role" {
    lifecycle_commands {
        create = <<-EOF
          tanzu tmc iam role create -f ${var.policy-file}
        EOF
        update = <<-EOF
           tanzu tmc iam role update -f ${var.policy-file}
        EOF
        delete = <<-EOF
           tanzu tmc iam role delete ${local.role-name}
        EOF
    }
}
