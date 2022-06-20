# This file contains local & data blocks
data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {
}


#Create the local variables
locals {
  client_id       = data.azurerm_client_config.current.client_id
  tenant_id       = data.azurerm_client_config.current.tenant_id
  object_id       = data.azurerm_client_config.current.object_id
  subscription_id = data.azurerm_subscription.current.subscription_id
}

# TODO : Add data block based lookup
locals {
  route_table_id = var.route_table.id == null ? (
    var.route_table.name == null && var.route_table.resource_group_name == null && var.route_table.virtual_hub.name == null ? (
      var.route_tables[var.route_table.key].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.route_table.resource_group_name}/providers/Microsoft.Network/virtualHubs/${var.route_table.virtual_hub_name}/routeTables/${var.route_table.name}"
  ) : var.route_table.id

  next_hop_id = var.next_hop.id == null ? (
    var.next_hop.name == null && var.next_hop.resource_group_name == null && var.next_hop.virtual_hub_name == null ? (
      var.virtual_hub_connections[var.next_hop.key].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.next_hop.resource_group_name}/providers/Microsoft.Network/virtualHubs/${var.next_hop.virtual_hub_name}/hubVirtualNetworkConnections/${var.next_hop.name}"
  ) : var.next_hop.id
}

