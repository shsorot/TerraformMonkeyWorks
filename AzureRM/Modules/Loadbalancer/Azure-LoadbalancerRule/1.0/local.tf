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

# <TODO> replace all raw resource ID's with appropriate data blocks when made available by Terraform
locals {
  loadbalancer_id = var.loadbalancer.id == null ? (
    var.loadbalancer.name == null ? (
      var.loadbalancers[var.loadbalancer.key].id
    ) : data.azurerm_lb.this[0].id
  ) : var.loadbalancer.id

  # TODO : add code for dual pool ids when LD is type "Gateway"
  # backend_address_pool_ids = var.backend_address_pool.id == null ? (
  #   var.backend_address_pool.backend_address_pool_name == null ? (
  #     var.backend_address_pools[var.backend_address_pool.key].id
  #   ) : "${local.loadbalancer_id}/backendAddressPools/${var.backend_address_pool.backend_address_pool_name}"
  # ) : var.backend_address_pool.id

  backend_address_pool_ids = [for instance in var.backend_address_pool : (
    instance.id == null ? (
      instance.backend_address_pool_name == null ? (
        var.backend_address_pools[instance.key].id
      ) : "${local.loadbalancer_id}/backendAddressPools/${instance.backend_address_pool_name}"
    ) : instance.id
  ) if(instance != null) || (instance != {})]

  probe_id = var.probe == null ? null : (
    var.probe.id == null ? (
      var.probe.name == null ? (
        var.probes[var.probe.key].id
      ) : "${local.loadbalancer_id}/probes/${var.probe.name}"
    ) : var.probe.id
  )
}