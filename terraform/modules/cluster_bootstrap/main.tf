

resource "local_sensitive_file" "kubeconfig" {
    content     = base64decode(var.kubeconfig)
    filename = "${path.module}/kubeconfig"
}

resource "local_sensitive_file" "akv-secret" {
       content     = templatefile("${path.module}/akv-secret.tftpl",{
        azure_client_id = base64encode(var.azure_client_id)
        azure_client_secret = base64encode(var.azure_client_secret)
    })
    filename = "${path.module}/akv-secret.yml"
}


resource "shell_script" "akv_bootstrap" {
  sensitive_environment = {
    KUBECONFIG = "${path.module}/kubeconfig"
  }
  lifecycle_commands {
    create = <<-EOF
          kubectl apply -f  ${path.module}/akv-secret.yml
        EOF
    update = <<-EOF
           kubectl apply -f ${path.module}/akv-secret.yml
        EOF
    delete =  <<-EOF
           kubectl delete -f ${path.module}/akv-secret.yml
        EOF
  }
  depends_on = [ local_sensitive_file.kubeconfig,local_sensitive_file.akv-secret ]

}
