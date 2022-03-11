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
  resource_group_name     = var.resource_group.name == null ? var.resource_groups[var.resource_group.tag].name : data.azurerm_resource_group.this[0].name
  resource_group_tags     = var.resource_group.name == null ? var.resource_groups[var.resource_group.tag].tags : data.azurerm_resource_group.this[0].tags
  tags                    = merge(var.tags, (var.inherit_tags == true ? local.resource_group_tags : {}))
  resource_group_location = var.resource_group.name == null ? var.resource_groups[var.resource_group.tag].location : data.azurerm_resource_group.this[0].location
  location                = var.location == null ? local.resource_group_location : var.location
}


data "azurerm_virtual_wan" "this"{
  count = var.virtual_wan == null || var.virtual_wan == {} ? 0 : (var.virtual_wan.name == null ? 1 : 0)
  name                = var.virtual_wan.name
  resource_group_name = coalesce(var.virtual_wan.resource_group_name,local.resource_group_name)
}

locals {
  virtual_wan_id = var.virtual_wan == null ? null : (var.virtual_wan.id == null ? (
    var.virtual_wan.name == null ? (
        var.virtual_wans[var.virtual_wan.tag].id
    ) : data.azurerm_virtual_wan.this[0].id
    ) : var.virtual_wan.id
  )
}