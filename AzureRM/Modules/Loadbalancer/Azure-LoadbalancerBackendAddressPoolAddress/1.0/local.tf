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

data "azurerm_virtual_network" "this" {
  count               = var.virtual_network.name == null && var.virtual_network.resource_group_name == null ? 0 : 1
  name                = var.virtual_network.name
  resource_group_name = var.virtual_network.resource_group_name
}

data "azurerm_lb" "this" {
  count               = var.backend_address_pool.loadbalancer_name == null && var.backend_address_pool.resource_group_name == null ? 0 : 1
  name                = var.backend_address_pool.loadbalancer_name
  resource_group_name = var.backend_address_pool.resource_group_name
}

data "azurerm_lb_backend_address_pool" "this" {
  count           = var.backend_address_pool.name == null && var.backend_address_pool.loadbalancer_name == null && var.backend_address_pool.resource_group_name == null ? 0 : 1
  name            = var.backend_address_pool.name
  loadbalancer_id = data.azurerm_lb.this[0].id
}

locals {
  virtual_network_id = var.virtual_network.id == null ? (
    var.virtual_network.name == null && var.virtual_network.resource_group_name == null ? (
      var.virtual_networks[var.virtual_network.key].id
    ) : data.azurerm_virtual_network.this[0].id
  ) : var.virtual_network.id


  backend_address_pool_id = var.backend_address_pool.id == null ? (
    var.backend_address_pool.name == null && var.backend_address_pool.loadbalancer_name == null && var.backend_address_pool.resource_group_name == null ? (
      var.backend_address_pools[var.backend_address_pool.key].id
    ) : data.azurerm_lb_backend_address_pool.this[0].id
  ) : var.backend_address_pool.id
}