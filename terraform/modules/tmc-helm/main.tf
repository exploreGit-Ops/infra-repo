resource "shell_script" "helm-tmc" {
    lifecycle_commands {
        create = <<-EOF
          tanzu tmc helm enable -g ${var.cluster_group} -s ${var.scope}
        EOF
        update = <<-EOF
          tanzu tmc helm enable -g ${var.cluster_group} -s ${var.scope}
        EOF
        delete = <<-EOF
          tanzu tmc helm disable -g ${var.cluster_group} -s ${var.scope}
        EOF
    }
}
