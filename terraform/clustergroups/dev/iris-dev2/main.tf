// Create Tanzu Mission Control AWS EKS cluster entry
resource "tanzu-mission-control_akscluster" "tf_aks_cluster" {
  credential_name = "sp-aks-creds" // Required
  subscription_id    = "d37d2a44-e6cc-434c-9e82-190ab5a1edf4"    // Required
  resource_group  = "my-resource-grp-sp"  // Required
  name            = "iris-dev2"    // Required

  meta {
    description = "aks iris dev cluster"
    labels      = { "terraform" : "true" }
  }

  spec {
    cluster_group = "dev" // Default: default
    config {
      location                 = "westus2" // Required     // Force Recreate
      kubernetes_version                  = "1.25.11"  // Required
      node_resource_group_name = "MC_my-resource-grp-sp_iris-dev-2_uswest2" // Force Recreate

      sku {
        name = "BASIC"
        tier = "PAID" // Required
      }

    
      network_config {
        // Required
        load_balancer_sku  = "standard"  // Forces Recreate
        network_plugin     = "kubenet"     // Forces Recreate
        dns_service_ip     = "10.0.0.10"     // Forces Recreate
        docker_bridge_cidr = "172.17.0.1/16" // Forces Recreate
        pod_cidr           = [
          // Forces Recreate
          "10.244.0.0/16"
        ]
        service_cidr = [
          // Forces Recreate
          "10.0.0.0/26"
        ]
        dns_prefix                      = "iris-dev2-dns" // Required
      }

      storage_config {
        enable_disk_csi_driver     = true
        enable_file_csi_driver     = true
        enable_snapshot_controller = true
      }

      auto_upgrade_config {
        upgrade_channel = "STABLE"
      }
    }
    nodepool {
      name = "systemnp"
      spec  {
            mode              = "SYSTEM" // Required
            type              = "VIRTUAL_MACHINE_SCALE_SETS"
            availability_zones = [
              "1",
              "2",
              "3"
            ]
            count                     = 1 // Required
            vm_size                   = "Standard_DS2_v2" // Required // Force Recreate
            os_type                   = "Linux"
            os_disk_type              = "Managed"        // Force Recreate
            max_pods                  = 110                      // Force Recreate
            enable_node_public_ip     = false

            auto_scaling_config  {
              enable    = true // Force Recreate
              min_count = 1
              max_count = 5
            }

            upgrade_config  {
              max_surge = "30%"
            }
          }
    }

    }
  }