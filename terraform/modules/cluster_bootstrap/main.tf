
resource "random_string" "random_suffix" {
  length  = 3
  special = false
  upper   = false
  keepers = {
    cluster_name = var.cluster_name
  }
}
resource "local_sensitive_file" "kubeconfig" {
    content     = base64decode(var.kubeconfig)
    filename = "${path.module}/kubeconfig-${random_string.random_suffix.result}"
}

resource "local_sensitive_file" "akv-secret" {
       content     = templatefile("${path.module}/akv-secret.tftpl",{
        azure_client_id = base64encode(var.azure_client_id)
        azure_client_secret = base64encode(var.azure_client_secret)
    })
    filename = "${path.module}/akv-secret-${random_string.random_suffix.result}.yml"
}


resource "shell_script" "akv_bootstrap" {
  sensitive_environment = {
    KUBECONFIG = local_sensitive_file.kubeconfig.filename
  }
  lifecycle_commands {
    create = <<-EOF
          kubectl apply -f  ${local_sensitive_file.akv-secret.filename}
        EOF
    update = <<-EOF
           kubectl apply -f ${local_sensitive_file.akv-secret.filename}
        EOF
    delete =  <<-EOF
           kubectl delete -f ${local_sensitive_file.akv-secret.filename}
        EOF
  }
  depends_on = [ local_sensitive_file.kubeconfig,local_sensitive_file.akv-secret ]

}
