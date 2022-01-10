# This file contains local & data blocks

data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {
}


#Create the local variables
locals {
  client_id           = data.azurerm_client_config.current.client_id
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
  subscription_id     = data.azurerm_subscription.current.subscription_id
  resource_group_name = var.loadbalancer.resource_group_name == null ? var.resource_group_name : var.loadbalancer.resource_group_name
}

data "azurerm_lb" "this" {
  count               = var.loadbalancer.name == null && var.loadbalancer.resource_group_name == null ? 0 : 1
  name                = var.loadbalancer.name
  resource_group_name = var.loadbalancer.resource_group_name
}

locals {
  loadbalancer_id = var.loadbalancer.id == null ? (
    var.loadbalancer.name == null && var.loadbalancer.resource_group_name == null ? (
      var.loadbalancers[var.loadbalancer.tag].id
    ) : data.azurerm_lb.this[0].id
  ) : var.loadbalancer.id
}