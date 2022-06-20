# This file contains local & data blocks
data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {
}


data "azurerm_resource_group" "this" {
  count = var.resource_group.name == null ? 0 : 1
  name  = var.resource_group.name
}

#Create the local variables
locals {
  client_id               = data.azurerm_client_config.current.client_id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_client_config.current.object_id
  subscription_id         = data.azurerm_subscription.current.subscription_id
  resource_group_name     = var.resource_group.name == null ? var.resource_groups[var.resource_group.key].name : data.azurerm_resource_group.this[0].name
  resource_group_tags     = var.resource_group.name == null ? var.resource_groups[var.resource_group.key].tags : data.azurerm_resource_group.this[0].tags
  tags                    = merge(var.tags, (var.inherit_tags == true ? local.resource_group_tags : {}))
  resource_group_location = var.resource_group.name == null ? var.resource_groups[var.resource_group.key].location : data.azurerm_resource_group.this[0].location
}

# Data block used by virtual_network_id
data "azurerm_virtual_network" "this" {
  count     = var.virtual_network.name == null ? 0 : 1
  name     = var.virtual_network.name
  resource_group_name = coalesce(var.virtual_network.resource_group_name,local.resource_group_name)
}

locals {
  virtual_network_id = var.virtual_network.id == null ? (
    var.virtual_network.name == null ? (
      var.virtual_networks[var.virtual_network.key].id
    ) : data.azurerm_virtual_network.this[0].id
  ) : var.virtual_network.id

  private_dns_zone_name = var.private_dns_zone.name == null ? var.private_dns_zones[var.private_dns_zone.key].name : var.private_dns_zone.name
}