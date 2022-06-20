# TODO : Add data block based lookup
resource "azurerm_network_interface_application_security_group_association" "this" {
  network_interface_id = var.network_interface.id == null ? (
    var.network_interface.name == null ? (
      var.network_interface[var.network_interface.key].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.network_interface.resource_group_name == null ? local.resource_group_name : var.network_interface.resource_group_name}/providers/Microsoft.Network/networkInterfaces/${var.network_interface.name}"
  ) : var.network_interface.id

  application_security_group_id = var.application_security_group.id == null ? (
    var.application_security_group.name == null ? (
      var.application_security_groups[var.application_security_group.key].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.application_security_group.resource_group_name == null ? local.resource_group_name : var.application_security_group.resource_group_name}/providers/Microsoft.Network/applicationSecurityGroups/${var.application_security_group.name}"
  ) : var.application_security_group.id
}