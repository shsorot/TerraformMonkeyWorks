# This file contains local & data blocks
data "azurerm_subscription" "current" {
}


#Create the local variables
locals {
  subscription_id = data.azurerm_subscription.current.subscription_id
}
# <TODO> replace all raw resource ID's with appropriate data blocks
locals {
  resource_group_name = var.loadbalancer.resource_group_name == null ? var.resource_group_name : var.loadbalancer.resource_group_name
  loadbalancer_id = var.loadbalancer.id == null ? (
    var.loadbalancer.name == null ? (
      var.loadbalancers[var.loadbalancer.loadbalancer_tag].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Network/loadBalancers/${var.backend_address_pool.loadbalancer_name}"
  ) : var.loadbalancer.id
  backend_address_pool_id = var.backend_address_pool.id == null ? (
    var.backend_address_pool.backend_address_pool_name == null ? (
      var.backend_address_pools[var.backend_address_pool.tag].id
    ) : "${local.loadbalancer_id}/backendAddressPools/${var.backend_address_pool.backend_address_pool_name}"
  ) : var.backend_address_pool.id

  probe_id = var.probe == null ? null : (
    var.probe.id == null ? (
      var.probe.name == null ? (
        var.probes[var.probe.tag].id
      ) : "${local.loadbalancer_id}/probes/${var.probe.name}"
    ) : var.probe.id
  )
}