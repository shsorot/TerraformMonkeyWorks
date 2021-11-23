# This file contains local & data blocks
data "azurerm_subscription" "current" {
}

data "azurerm_resource_group" "this" {
  count = var.resource-group.name == null ? 0 : 1
  name  = var.resource-group.name
}

#Create the local variables
locals {
  subscription_id = data.azurerm_subscription.current.subscription_id
  # network-tags        =   merge(var.tags,( var.inherit_tags == true ? data.azurerm_resource_group.vnet-rg.tags : {} ))
  # vm-tags             =   merge(var.tags,( var.inherit_tags == true ? data.azurerm_resource_group.vm-rg.tags : {} ))
  resource_group_tags     = var.resource-group.name == null ? var.resource_groups[var.resource-group.tag].tags : data.azurerm_resource_group.this[0].tags
  tags                    = merge(var.tags, (var.inherit_tags == true ? local.resource_group_tags : {}))
  resource_group_location = var.resource-group.name == null ? var.resource_groups[var.resource-group.tag].location : data.azurerm_resource_group.this[0].location
  location                = var.location == null ? local.resource_group_location : var.location

  resource_group_name                 = var.resource-group.name == null ? var.resource_groups[var.resource-group.tag].name : data.azurerm_resource_group.this[0].name
  virtual-machine-resource-group-name = local.resource_group_name

  key-vault-id = var.keyvault.id == null ? var.keyvaults[var.keyvault.tag].id : var.keyvault.id

  virtual-network-id  = var.virtual-network.id == null ? var.virtual_networks[var.virtual-network.tag].id : var.virtual-network.id
  mgmt-subnet-id      = "${local.virtual-network-id}/subnets/${var.mgmt-subnet-name}"
  untrusted-subnet-id = "${local.virtual-network-id}/subnets/${var.untrusted-subnet-name}"
  trusted-subnet-id   = "${local.virtual-network-id}/subnets/${var.trusted-subnet-name}"

  external-load-balancer-id                               = var.untrusted-external-loadbalancer.id == null ? var.loadbalancers[var.untrusted-external-loadbalancer.tag].id : var.untrusted-external-loadbalancer.id
  internal-load-balancer-id                               = var.untrusted-internal-loadbalancer.id == null ? var.loadbalancers[var.untrusted-internal-loadbalancer.tag].id : var.untrusted-internal-loadbalancer.id
  untrusted-external-loadbalancer-backend-address-pool-id = "${local.external-load-balancer-id}/backendAddressPools/${var.untrusted-external-loadbalancer-backend-address-pool-name}"
  untrusted-internal-loadbalancer-backend-address-pool-id = "${local.internal-load-balancer-id}/backendAddressPools/${var.untrusted-internal-loadbalancer-backend-address-pool-name}"

  admin-password = var.admin-password == null || var.admin-password == "" ? random_password.credential-value.result : var.admin-password
}
