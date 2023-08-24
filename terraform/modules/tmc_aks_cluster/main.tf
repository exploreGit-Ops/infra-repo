resource "tanzu-mission-control_akscluster" "tf_aks_cluster" {
  credential_name = "sp-aks-creds" // Required
  subscription_id    = "d37d2a44-e6cc-434c-9e82-190ab5a1edf4"    // Required
  resource_group  = "my-resource-grp-sp"  // Required
  name            = var.cluster_name    // Required

  meta {
    description = "aks iris dev cluster"
    labels      = { "terraform" : "true" }
  }

  spec {
    cluster_group = var.cluster_group // Default: default
    config {
      location                 = "westus2" // Required     // Force Recreate
      kubernetes_version                  = "1.25.11"  // Required
      node_resource_group_name = "MC_my-resource-grp-sp_${var.cluster_name}_uswest2" // Force Recreate

      sku {
        name = "BASIC"
        tier = "PAID" // Required
      }


      network_config {
        // Required
        load_balancer_sku  = "standard"  // Forces Recreate
        network_plugin     = "kubenet"     // Forces Recreate
        dns_service_ip     = "10.0.0.10"     // Forces Recreate
       
        dns_prefix                      = "${var.cluster_name}-dns" // Required
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
            count                     = 3 // Required
            vm_size                   = "Standard_DS2_v2" // Required // Force Recreate
            max_pods                  = 110                      // Force Recreate
            enable_node_public_ip     = false

            auto_scaling_config  {
              enable    = true // Force Recreate
              min_count = 3
              max_count = 5
            }

            upgrade_config  {
              max_surge = "30%"
            }
          }
    }

    }
  }

data "shell_script" "tmc_kubeconfig" {
    lifecycle_commands {
        read = <<-EOF
          echo "{\"kubeconfig\": \"$(tanzu tmc cluster kubeconfig get ${tanzu-mission-control_akscluster.tf_aks_cluster.spec[0].agent_name} -m aks -p aks | base64)\"}" 
        EOF
    }
}

output "kubeconfig" {
    value = data.shell_script.tmc_kubeconfig.output.kubeconfig
}

output "cluster_name" {
    value = tanzu-mission-control_akscluster.tf_aks_cluster.name
}