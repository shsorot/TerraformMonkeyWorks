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
# TODO : Add data block based lookup
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

locals {
  dedicated_cluster_id = var.dedicated_cluster == null ? null : (
    var.dedicated_cluster.id == null ? (
      var.dedicated_cluster.name == null ? (
        var.dedicated_clusters[var.dedicated_cluster.key].id
      ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.dedicated_cluster.resource_group_name == null ? local.resource_group_name : var.dedicated_cluster.resource_group_name}/providers/Microsoft.EventHub/clusters/${var.dedicated_cluster.name}"
    ) : var.dedicated_cluster.id
  )
}