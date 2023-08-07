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