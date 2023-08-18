
locals {
  akv-secret = templatefile("${path.module}/akv-secret.tftpl",{
        azure_client_id = base64encode(var.azure_client_id)
        azure_client_secret = base64encode(var.azure_client_secret)
    })
}

resource "shell_script" "akv_bootstrap" {
  interpreter = ["/bin/bash", "-c"]
  sensitive_environment = {
    KUBECONFIG_DATA = var.kubeconfig
    AKV_SECRET =  base64encode(local.akv-secret)
  }
  lifecycle_commands {
    create = <<-EOF
          kubectl apply -f <(echo $AKV_SECRET | base64 -d) --kubeconfig <(echo $KUBECONFIG_DATA | base64 -d)
        EOF
    update = <<-EOF
           kubectl apply -f <(echo $AKV_SECRET | base64 -d) --kubeconfig <(echo $KUBECONFIG_DATA | base64 -d)
        EOF
    delete =  <<-EOF
           kubectl delete -f <(echo $AKV_SECRET | base64 -d) --kubeconfig <(echo $KUBECONFIG_DATA | base64 -d)
        EOF
  }

}
