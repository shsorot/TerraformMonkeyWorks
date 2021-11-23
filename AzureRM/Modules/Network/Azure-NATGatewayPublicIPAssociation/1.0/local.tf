# This file contains local & data blocks
data "azurerm_subscription" "current" {
}

#Create the local variables
locals {
  subscription_id = data.azurerm_subscription.current.subscription_id
  nat_gateway_id = var.nat_gateway.id == null ? (
    var.nat_gateway.name == null && var.nat_gateway.resource_group_name == null ? (
      var.nat_gateways[var.nat_gateway.tag].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.nat_gateway.resource_group_name}/providers/Microsoft.Network/natGateways/${var.nat_gateway.name}"
  ) : var.nat_gateway.id
  public_ip_address_id = var.public_ip_address.id == null ? (
    var.public_ip_address.name == null && var.public_ip_address.resource_group_name == null ? (
      var.public_ip_addresses[var.public_ip_address.tag].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.public_ip_address.resource_group_name}/providers/Microsoft.Network/publicIPAddresses/${var.public_ip_address.name}"
  ) : var.public_ip_address.id
}