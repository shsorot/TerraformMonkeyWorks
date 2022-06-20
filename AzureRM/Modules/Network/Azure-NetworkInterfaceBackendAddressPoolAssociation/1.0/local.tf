# This file contains local & data blocks
data "azurerm_subscription" "current" {
}


#Create the local variables
# TODO : Add data block based lookup
locals {
  subscription_id = data.azurerm_subscription.current.subscription_id
  network_interface_id = var.network_interface.id == null ? (
    var.network_interface.name == null && var.network_interface.resource_group_name ? (
      var.network_interface[var.network_interface.key].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.network_interface.resource_group_name}/providers/Microsoft.Network/networkInterfaces/${var.network_interface.name}"
  ) : var.network_interface.id
  backend_address_pool_id = var.backend_address_pool.id == null ? (
    var.backend_address_pool.backend_address_pool_name == null && var.backend_address_pool.loadbalancer_name == null && var.backend_address_pool.resource_group_name == null ? (
      var.backend_address_pools[var.backend_address_pool.key].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.backend_address_pool.resource_group_name}/providers/Microsoft.Network/loadBalancers/${var.backend_address_pool.loadbalancer_name}/backendAddressPools/${var.backend_address_pool.backend_address_pool_name}"
  ) : var.backend_address_pool.id
}