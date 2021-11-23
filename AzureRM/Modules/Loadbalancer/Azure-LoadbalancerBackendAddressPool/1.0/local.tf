# This file contains local & data blocks
data "azurerm_subscription" "current" {
}


#Create the local variables
locals {
  subscription_id = data.azurerm_subscription.current.subscription_id
  loadbalancer_id = var.loadbalancer.id == null ? (
    var.loadbalancer.name == null && var.loadbalancer.resource_group_name == null ? (
      var.loadbalancers[var.loadbalancer.tag].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.loadbalancer.resource_group_name}/providers/Microsoft.Network/loadBalancers/${var.loadbalancer.name}"
  ) : var.loadbalancer.id
}