// Create Tanzu Mission Control AWS EKS cluster entry
resource "tanzu-mission-control_ekscluster" "tf_eks_cluster" {
  credential_name = "sp-eks-new" // Required
  region          = "us-east-2"          // Required
  name            = "iris-dev2"        // Required

  ready_wait_timeout = "30m" // Wait time for cluster operations to finish (default: 30m).

  meta {
    description = "description of the cluster"
    labels      = { "mode" : "automation", "username" : "sp" }
  }

  spec {
    cluster_group = "dev" // Default: default
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
        subnet_ids = [ // Forces new
           "subnet-0da4532cf7ceabcf2",
          "subnet-017deb270cb808857",
           "subnet-02c618d32cf78be79",
          "subnet-0b2346462a0831132"
        ]
      }
    }

    nodepool {
      info {
        name        = "large-pool" // Required
        description = "nodepool for eks cluster"
      }

      spec {
        // Refer to nodepool's schema
        role_arn       = "arn:aws:iam::687456942232:role/worker.17276895336783884699.eks.tmc.cloud.vmware.com" // Required
        ami_type       = "CUSTOM"
        capacity_type  = "ON_DEMAND"
        root_disk_size = 40 // In GiB, default: 20GiB
        tags           = { "mode" : "automation" }
        node_labels    = { "tool" : "tf" }

        subnet_ids = [ // Required
          "subnet-0da4532cf7ceabcf2",
          "subnet-017deb270cb808857"
        ]

      ami_info {
        ami_id = "ami-09bc3e8855823484f"
        override_bootstrap_cmd = "#!/bin/bash\n/etc/eks/bootstrap.sh iris-test"
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


    # nodepool {
    #   info {
    #     name        = "second-np"
    #     description = "second np for eks"
    #   }

    #   spec {
    #     role_arn    = "arn:aws:iam::687456942232:role/worker.17276895336783884699.eks.tmc.cloud.vmware.com" // Required
    #     tags        = { "nptag" : "nptagvalue7" }
    #     ami_type       = "CUSTOM"
    #     node_labels = { "nplabelkey" : "nplabelvalue" }

    #     subnet_ids = [ // Required
    #       "subnet-0d5629bf282e045e0",
    #       "subnet-0c491fcf640355ffa",
    #       "subnet-0a8fdf79f6efe263a",
    #       "subnet-047d87edac86e8138"
    #     ]

    #     launch_template {
    #       name    = "myLaunchTemplate"
    #       version = "5"
    #     }

    #     scaling_config {
    #       desired_size = 2
    #       max_size     = 4
    #       min_size     = 1
    #     }

    #     update_config {
    #       max_unavailable_percentage = "12"
    #     }

    #     taints {
    #       effect = "PREFER_NO_SCHEDULE"
    #       key    = "randomkey"
    #       value  = "randomvalue"
    #     }
    #   }
    # }
  }
}
