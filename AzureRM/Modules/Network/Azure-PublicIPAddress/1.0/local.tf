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

# TODO : Add data block based lookup
locals {
  public_ip_prefix_id = var.public_ip_prefix == null || var.public_ip_prefix == {} ? null : (
    var.public_ip_prefix.id == null ? (
      var.public_ip_prefix.name == null ? (
        var.public_ip_prefixes[var.public_ip_prefix.key].id
      ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.public_ip_prefix.resource_group_name == null ? local.resource_group_name : var.public_ip_prefix.resource_group_name}/providers/Microsoft.Network/publicIPPrefixes/${var.public_ip_prefix.name}"
    ) : var.public_ip_prefix.id
  )

}
