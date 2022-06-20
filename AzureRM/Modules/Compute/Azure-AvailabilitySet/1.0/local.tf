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
  location                = var.location == null ? local.resource_group_location : var.location
}

data "azurerm_proximity_placement_group" "this" {
  count               = var.proximity_placement_group == null || var.proximity_placement_group == {} ? 0 : (var.proximity_placement_group.name == null ? 0 : 1)
  name                = var.proximity_placement_group.name
  resource_group_name = coalesce(var.proximity_placement_group.resource_group_name, local.resource_group_name)
}

locals {
  proximity_placement_group_id = var.proximity_placement_group == null ? null : (
    var.proximity_placement_group.id == null ? (
      var.proximity_placement_group.name == null ? (
        var.proximity_placement_groups[var.proximity_placement_group.key].id
      ) : data.azurerm_proximity_placement_group.this[0].id
    ) : var.proximity_placement_group.id
  )
}