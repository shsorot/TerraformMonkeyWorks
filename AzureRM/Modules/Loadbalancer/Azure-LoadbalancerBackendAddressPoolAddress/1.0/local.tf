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
locals {
  virtual_network_id = var.virtual_network.id == null ? (
    var.virtual_network.name == null ? (
      var.virtual_networks[var.virtual_network.tag].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.virtual_network.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.virtual_network.name}"
  ) : var.virtual_network.id
  backend_address_pool_id = var.backend_address_pool.id == null ? (
    var.backend_address_pool.backend_address_pool_name == null && var.backend_address_pool.loadbalancer_name == null && var.backend_address_pool.resource_group_name == null ? (
      var.backend_address_pools[var.backend_address_pool.tag].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.backend_address_pool.resource_group_name}/providers/Microsoft.Network/loadBalancers/${var.backend_address_pool.loadbalancer_name}/backendAddressPools/${var.backend_address_pool.backend_address_pool_name}"
  ) : var.backend_address_pool.id
}