// Create Tanzu Mission Control AWS EKS cluster entry
resource "tanzu-mission-control_akscluster" "tf_aks_cluster" {
  credential_name = "sp-aks-cred" // Required
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

      # access_config {
      #   enable_rbac            = true
      #   disable_local_accounts = true
      # }

      # api_server_access_config {
        # authorized_ip_ranges = [
        #   "73.140.245.0/24",
        #   "71.952.241.0/32",
        # ]
        # enable_private_cluster = false // Forces Recreate
      # }

      # linux_config {
      #   // Force Recreate
      #   admin_username = "test-admin-username"
      #   ssh_keys       = [
      #     "test-ssh-key-1",
      #     "test-ssh-key-2",
      #   ]
      # }

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

      # addons_config {
      #   azure_keyvault_secrets_provider_addon_config {
      #     enable = true
      #     keyvault_secrets_provider_config {
      #       enable_secret_rotation = true
      #       rotation_poll_interval = "5m"
      #     }
      #   }

      #   monitor_addon_config {
      #     enable                     = true
      #     log_analytics_workspace_id = "test-log-analytics-workspace-id"
      #   }

      #   azure_policy_addon_config {
      #     enable = true
      #   }
      # }

      auto_upgrade_config {
        upgrade_channel = "stable"
      }
    }
    nodepool {
      name = "systemnp"
      spec  {
            mode              = "System" // Required
            type              = "VIRTUAL_MACHINE_SCALE_SETS"
            availabilityZones = [
              "1",
              "2",
              "3"
            ]
            count                     = 1 // Required
            vm_size                   = "Standard_DS2_v2" // Required // Force Recreate
            # scale_set_priority        = "Regular"// Force Recreate
            # scale_set_eviction_policy = "Delete" // Force Recreate
            # spot_max_price            = 1.00
            os_type                   = "Linux"
            os_disk_type              = "Managed"        // Force Recreate
            # os_disk_size_gb           =                       // Force Recreate
            max_pods                  = 110                      // Force Recreate
            enable_node_public_ip     = false
            # node_taints               = [
            #   {
            #     effect = "NoSchedule"
            #     key    = "randomkey"
            #     value  = "randomvalue"
            #   }
            # ]
            # vnet_subnet_id = "test-vnet-subnet-id" // Force Recreate
            # node_labels    = { "nplabelkey" : "nplabelvalue" }
            # tags           = { "nptagkey" : "nptagvalue3" }

            auto_scaling_config = {
              enable    = true // Force Recreate
              min_count = 1
              max_count = 5
            }

            upgrade_config = {
              max_surge = "30%"
            }
          }
    }

    }
  }