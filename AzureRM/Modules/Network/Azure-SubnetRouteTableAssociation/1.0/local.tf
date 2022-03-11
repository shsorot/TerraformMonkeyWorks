# This file contains local & data blocks
data "azurerm_subscription" "current" {
}

data "azurerm_subnet" "this" {
  count                = var.subnet.name == null && var.subnet.virtual_network_name == null ? 0 : 1
  name                 = var.subnet.name
  resource_group_name  = var.subnet.resource_group_name
  virtual_network_name = var.subnet.virtual_network_name
}

data "azurerm_route_table" "this" {
  count               = var.route_table.name == null && var.route_table.resource_group_name == null ? 0 : 1
  name                = var.route_table.name
  resource_group_name = var.route_table.resource_group_name
}

#Create the local variables
locals {
  subscription_id = data.azurerm_subscription.current.subscription_id
  subnet_id = var.subnet.id == null ? (
    var.subnet.name == null && var.subnet.virtual_network_name == null ? (
      var.virtual_networks[var.subnet.virtual_network_tag].subnet[var.subnet.tag].id
    ) : data.azurerm_subnet.this[0].id
  ) : var.subnet.id

  route_table_id = var.route_table.id == null ? (
    var.route_table.name == null && var.route_table.resource_group_name == null ? (
      var.route_tables[var.route_table.tag].id
    ) : data.azurerm_route_table.this[0].id
  ) : var.route_table.id
}
