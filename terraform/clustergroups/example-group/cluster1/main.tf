## create cluster code


## get cluster kubeconfig

resource "terraform_data" "cluster" {

  provisioner "local-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    command = "tanzu tmc cluster kubeconfig get eks.eks-warroyo2.us-west-2.tap-flux -m eks -p eks"
  }
}


## bootstrap with secret