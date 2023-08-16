// Create Tanzu Mission Control AWS EKS cluster entry
resource "tanzu-mission-control_ekscluster" "tf_eks_cluster" {
  credential_name = var.eks_credential // Required
  region          = var.region          // Required
  name            = var.cluster_name      // Required

  ready_wait_timeout = "30m" // Wait time for cluster operations to finish (default: 30m).

  meta {
    description = "created with TF"
    labels      = { "mode" : "automation" }
  }

  spec {
    cluster_group = var.cluster_group // Default: default
    #proxy         = "" //if used 

    config {
      role_arn           = "arn:aws:iam::687456942232:role/control-plane.17276895336783884699.eks.tmc.cloud.vmware.com" // Required, forces new
      kubernetes_version = "1.25"                // Required
      tags               = { "mode" : "terraform" }

      kubernetes_network_config {
        service_cidr = "10.100.0.0/16" // Forces new
      }

      logging {
        api_server         = false
        audit              = true
        authenticator      = true
        controller_manager = false
        scheduler          = true
      }

      vpc { // Required
        enable_private_access = true
        enable_public_access  = true
        public_access_cidrs = [
          "0.0.0.0/0",
        ]
        security_groups = [ // Forces new
          "sg-008e4bd0de09ebc90",
        ]
        subnet_ids = var.subnet_ids
      }
    }

    nodepool {
      info {
        name        = "default-pool" // Required
        description = "initial pool for eks"
      }

      spec {
        // Refer to nodepool's schema
        role_arn       = "arn:aws:iam::687456942232:role/worker.17276895336783884699.eks.tmc.cloud.vmware.com" // Required
        ami_type       = "CUSTOM"
        capacity_type  = "ON_DEMAND"
        root_disk_size = 40 // In GiB, default: 20GiB
        tags           = { "mode" : "automation" }
        node_labels    = { "tool" : "tf" }

        subnet_ids = var.np_subnet_ids

      ami_info {
        ami_id = "ami-09bc3e8855823484f"
        override_bootstrap_cmd = "#!/bin/bash\n/etc/eks/bootstrap.sh ${var.cluster_name}"
      }

        remote_access {
          ssh_key = "sp-eks-east-2-tf-key" // Required (if remote access is specified)

          security_groups = [
            "sg-008e4bd0de09ebc90",
          ]
        }

        scaling_config {
          desired_size = 3
          max_size     = 5
          min_size     = 1
        }

        update_config {
          max_unavailable_nodes = "1"
        }

        instance_types = [
          "t3.xlarge"
        ]

      }
    }
  }
}


data "shell_script" "tmc_kubeconfig" {
    sensitive_environment = {
    TANZU_API_TOKEN = var.tmc-api-key
   }
    lifecycle_commands {
        read = <<-EOF
          tanzu context create tmc --endpoint ${var.tmc-endpoint}
          echo "{\"kubeconfig\": \"$(tanzu tmc cluster kubeconfig get eks.${var.eks_credential}.${var.region}.${tanzu-mission-control_ekscluster.tf_eks_cluster.name} -m eks -p eks | base64)\"}" 
        EOF
    }
}

output "kubeconfig" {
    value = data.shell_script.tmc_kubeconfig.output.kubeconfig
}