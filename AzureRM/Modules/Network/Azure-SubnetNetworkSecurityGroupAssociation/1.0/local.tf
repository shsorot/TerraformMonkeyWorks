# This file contains local & data blocks
data "azurerm_subscription" "current" {
}

#Create the local variables
# TODO : Add data block based lookup
locals {
  subscription_id = data.azurerm_subscription.current.subscription_id
  subnet_id = var.subnet.id == null ? (
    var.subnet.name == null && var.subnet.virtual_network_name == null && var.subnet.resource_group_name == null ? (
      var.virtual_networks[var.subnet.virtual_network_tag].subnet[var.subnet.key].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.subnet.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.subnet.virtual_network_name}/subnets/${var.subnet.name}"
  ) : var.subnet.id

  network_security_group_id = var.network_security_group.id == null ? (
    var.network_security_group.name == null && var.network_security_group.resource_group_name == null ? (
      var.network_security_groups[var.network_security_group.key].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.network_security_group.resource_group_name}/providers/Microsoft.Network/networkSecurityGroups/${var.network_security_group.name}"
  ) : var.network_security_group.id
}
