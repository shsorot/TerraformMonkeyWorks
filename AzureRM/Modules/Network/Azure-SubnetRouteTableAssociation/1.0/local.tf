# This file contains local & data blocks
data "azurerm_subscription" "current" {
}


#Create the local variables
locals {
  subscription_id = data.azurerm_subscription.current.subscription_id
  subnet_id = var.subnet.id == null ? (
    var.subnet.name == null && var.subnet.virtual_network_name == null && var.subnet.resource_group_name == null ? (
      var.virtual_networks[var.subnet.virtual_network_tag].subnet[var.subnet.tag].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.subnet.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.subnet.virtual_network_name}/subnets/${var.subnet.subnet.name}"
  ) : var.subnet.id
  route_table_id = var.route_table.id == null ? (
    var.route_table.name == null && var.route_table.resource_group_name == null ? (
      var.route_tables[var.route_table.tag].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.route_table.resource_group_name}/providers/Microsoft.Network/routeTables/${var.route_table.name}"
  ) : var.route_table.id
}
