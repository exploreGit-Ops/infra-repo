resource "tanzu-mission-control_akscluster" "tf_aks_cluster" {
  credential_name = var.credential_name // Required
  subscription_id    = var.subscription_id    // Required
  resource_group  = var.resource_group  // Required
  name            = var.cluster_name    // Required

  meta {
    description = "aks iris dev cluster"
    labels      = { "terraform" : "true" }
  }

  spec {
    cluster_group = var.cluster_group // Default: default
    config {
      location                 = var.region // Required     // Force Recreate
      kubernetes_version                  = var.k8s_version  // Required
      node_resource_group_name = "MC_${var.resource_group}_${var.cluster_name}_${var.region}" // Force Recreate

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
          set -e
          tanzu tmc cluster kubeconfig get ${tanzu-mission-control_akscluster.tf_aks_cluster.spec[0].agent_name} -m aks -p aks | while read line ; do 
            if echo "$line" | grep "apiVersion: v1" 
            then
              break
            else
              echo "$line"
            fi
          done
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