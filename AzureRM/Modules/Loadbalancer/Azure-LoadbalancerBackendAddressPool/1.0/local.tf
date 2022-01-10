# This file contains local & data blocks
data "azurerm_subscription" "current" {
}


#Create the local variables
locals {
  subscription_id = data.azurerm_subscription.current.subscription_id
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