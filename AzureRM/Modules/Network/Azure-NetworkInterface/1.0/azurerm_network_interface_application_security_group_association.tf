# TODO : Add data block based lookup
resource "azurerm_network_interface_application_security_group_association" "this" {
  count                = var.application_security_group == null ? 0 : 1
  network_interface_id = azurerm_network_interface.this.id
  application_security_group_id = var.application_security_group.id == null ? (
    var.application_security_group.name == null ? (
      var.application_security_groups[var.application_security_group.key].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.application_security_group.resource_group_name == null ? local.resource_group_name : var.application_security_group.resource_group_name}/providers/Microsoft.Network/applicationSecurityGroups/${var.application_security_group.name}"
  ) : var.application_security_group.id
}