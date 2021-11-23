resource "azurerm_network_interface_application_security_group_association" "this" {
  count                = var.application_security_group == null ? 0 : length(var.application_security_group)
  network_interface_id = azurerm_network_interface.this.id
  application_security_group_id = var.application_security_group[count.index].id == null ? (
    var.application_security_group[count.index].name == null ? (
      var.application_security_groups[var.application_security_group[count.index].tag].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.application_security_group[count.index].resource_group_name == null ? local.resource_group_name : var.application_security_group[count.index].resource_group_name}/providers/Microsoft.Network/applicationSecurityGroups/${var.application_security_group[count.index].name}"
  ) : var.application_security_group[count.index].id
}