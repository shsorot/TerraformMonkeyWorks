# This file contains local & data blocks
data "azurerm_subscription" "current" {
}


locals {
  #Create a remote virtual network ID string to create peering to.
  # Requries remote subscription ID , Virtual network name and the resource group it's kept in.
  subscription_id = data.azurerm_subscription.current.subscription_id

  local_name  = "${var.local_virtual_network.name}-to-${var.remote_virtual_network.name}-Peering"
  remote_name = "${var.remote_virtual_network.name}-to-${var.local_virtual_network.name}-Peering"
  local_virtual_network_id = var.local_virtual_network.name == null && var.local_virtual_network.resource_group_name == null ? (
    var.virtual_networks[var.local_virtual_network.tag].id
  ) : "/subscriptions/${var.local_virtual_network.subscription_id == null ? local.subscription_id : var.local_virtual_network.subscription_id}/resourceGroups/${var.local_virtual_network.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.local_virtual_network.name}"
  remote_virtual_network_id = var.remote_virtual_network.name == null && var.remote_virtual_network.resource_group_name == null ? (
    var.virtual_networks[var.remote_virtual_network.tag].id
  ) : "/subscriptions/${var.remote_virtual_network.subscription_id == null ? local.subscription_id : var.remote_virtual_network.subscription_id}/resourceGroups/${var.remote_virtual_network.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.remote_virtual_network.name}"
}
