# This file contains local & data blocks
data "azurerm_subscription" "current" {
}

#Create the local variables
# TODO : Add data block based lookup
locals {
  subscription_id = data.azurerm_subscription.current.subscription_id
  nat_gateway_id = var.nat_gateway.id == null ? (
    var.nat_gateway.name == null && var.nat_gateway.resource_group_name == null ? (
      var.nat_gateways[var.nat_gateway.key].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.nat_gateway.resource_group_name}/providers/Microsoft.Network/natGateways/${var.nat_gateway.name}"
  ) : var.nat_gateway.id

  subnet_id = var.subnet.id == null ? (
    var.subnet.name == null && var.subnet.virtual_network_name == null && var.subnet.resource_group_name == null ? (
      var.virtual_networks[var.subnet.virtual_network_tag].subnets[var.subnet.key].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.subnet.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.subnet.virtual_network_name}/subnets/${var.subnet.name}"
  ) : var.subnet.id
}