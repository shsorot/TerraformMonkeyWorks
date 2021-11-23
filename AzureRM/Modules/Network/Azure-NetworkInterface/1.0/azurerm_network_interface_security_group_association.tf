
resource "azurerm_network_interface_security_group_association" "this" {
  count                = try(var.network_security_group, null) == null ? 0 : 1
  network_interface_id = azurerm_network_interface.this.id
  network_security_group_id = var.network_security_group.id == null ? (
    var.network_security_group.name == null ? (
      var.network_security_groups[var.network_security_group.tag].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.network_security_group.resource_group_name == null ? local.resource_group_name : var.network_security_group.resource_group_name}/providers/Microsoft.Network/applicationSecurityGroups/${var.network_security_group.name}"
  ) : var.network_security_group.id
}


