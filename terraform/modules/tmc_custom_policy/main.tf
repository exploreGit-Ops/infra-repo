
locals {
  policy-name = yamldecode(data.local_file.policy-file.content).fullName.name
  cluster-group = yamldecode(data.local_file.policy-file.content).fullName.clusterGroupName
}

data "local_file" "policy-file" {
  filename = abspath(var.policy-file)
}


resource "shell_script" "create_policy_template" {
    lifecycle_commands {
        create = <<-EOF
          tanzu tmc policy create -f ${data.local_file.policy-file.filename} -s ${var.scope}
        EOF
        update = <<-EOF
          tanzu tmc policy update -f ${data.local_file.policy-file.filename} -s ${var.scope}
        EOF
        delete = <<-EOF
          tanzu tmc policy delete -n ${local.cluster-group} -s ${var.scope} ${local.policy-name}
        EOF
    }
}
