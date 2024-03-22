# Create Tanzu Mission Control cluster group
resource "tanzu-mission-control_cluster_group" "create_cluster_group" {
  name = "dev"
  meta {
    description = "Create cluster group through terraform"
    labels = {
      "cloud" : "public",
      "automation" : "terraform"
    }
  }
}

#Bootstrap cluster group secret for AKV

module "cg_bootstrap" {
  source = "../../modules/cluster_bootstrap/"
  azure_client_id = var.azure-client-id
  azure_client_secret = var.azure-client-secret
  cluster_group = tanzu-mission-control_cluster_group.create_cluster_group.name
}