
locals {
  template-contents = yamldecode(file(var.template-file))
  template-name = local.template-contents.metadata.name

}



resource "tanzu-mission-control_custom_policy_template" "create_policy_template" {
  name = local.template-name

  spec {
    object_type   = "ConstraintTemplate"
    template_type = "OPAGatekeeper"

    dynamic "data_inventory" {
      for_each = var.data-inventory
      content {
        # flipping the version and kind fields until bug here is fixed
        # https://github.com/vmware/terraform-provider-tanzu-mission-control/issues/389
        kind    =  data_inventory.value["version"]
        group   =  data_inventory.value["group"]
        version =  data_inventory.value["kind"]
      }
    }


    template_manifest = yamlencode(local.template-contents)
  }
}