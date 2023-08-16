
locals {
  template-name = yamldecode(file(var.template-file)).metadata.name
}



resource "shell_script" "create_policy_template" {
    lifecycle_commands {
        create = <<-EOF
          tanzu tmc policy policy-template create --object-file ${var.template-file} --data-inventory ${var.data-inventory}
        EOF
        update = <<-EOF
          tanzu tmc policy policy-template update --object-file ${var.template-file} --force --data-inventory ${var.data-inventory}
        EOF
        delete = <<-EOF
          tanzu tmc policy policy-template delete ${local.template-name}
        EOF
    }
}
