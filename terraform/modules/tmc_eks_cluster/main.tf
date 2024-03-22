// Create Tanzu Mission Control AWS EKS cluster entry
resource "tanzu-mission-control_ekscluster" "tf_eks_cluster" {
  credential_name = var.eks_credential // Required
  region          = var.region          // Required
  name            = var.cluster_name      // Required

  # ready_wait_timeout = "30m" // Wait time for cluster operations to finish (default: 30m).

  meta {
    description = "created with TF"
    labels      = { "mode" : "automation" }
  }

  spec {
    cluster_group = var.cluster_group // Default: default
    #proxy         = "" //if used 

    config {
      role_arn           = var.cp_role_arn // Required, forces new
      kubernetes_version = var.k8s_version              // Required
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
        security_groups = var.security_groups
        subnet_ids = var.subnet_ids
      }
    }

    nodepool {
      info {
        name        = "nodes-pool" // Required
        description = "initial pool for eks"
      }

      spec {
        // Refer to nodepool's schema
        role_arn       = var.worker_role_arn // Required
        ami_type       = "AL2_x86_64"
        capacity_type  = "ON_DEMAND"
        root_disk_size = 40 // In GiB, default: 20GiB
        tags           = { "mode" : "automation" }
        node_labels    = { "tool" : "tf" }

        subnet_ids = var.np_subnet_ids

      # ami_info {
      #   ami_id = "ami-09bc3e8855823484f"
      #   override_bootstrap_cmd = "#!/bin/bash\n/etc/eks/bootstrap.sh ${var.cluster_name}"
      # }


        scaling_config {
          desired_size = 3
          max_size     = 5
          min_size     = 1
        }

        update_config {
          max_unavailable_nodes = "1"
        }

        instance_types = [
          "m5.xlarge"
        ]

      }
    }
  }
}


output "cluster_name" {
    value = tanzu-mission-control_ekscluster.tf_eks_cluster.name
}