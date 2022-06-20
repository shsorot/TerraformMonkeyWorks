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

data "azurerm_subnet" "this" {
  count                = var.subnet.name == null && var.subnet.virtual_network_name == null ? 0 : 1
  name                 = var.subnet.name
  resource_group_name  = coalesce(var.subnet.resource_group_name, local.resource_group_name)
  virtual_network_name = var.subnet.virtual_network_name
}

data "azurerm_dns_zone" "this" {
  for_each            = var.private_dns_zone_group == null ? {} : { for instance in var.private_dns_zone_group.private_dns_zone : instance.name => instance if instance.name != null }
  name                = each.value.name
  resource_group_name = coalesce(each.value.resource_group_name, local.resource_group_name)
}

locals {
  subnet_id = var.subnet.id == null ? (
    var.subnet.name == null && var.subnet.virtual_network_name == null ? (
      var.virtual_networks[var.subnet.virtual_network_tag].subnet[var.subnet.key].id
    ) : data.azurerm_subnet.this[0].id
  ) : var.subnet.id

  private_dns_zone_group = var.private_dns_zone_group == null ? null : {
    name = var.private_dns_zone_group.name
    private_dns_zone_ids = [for instance in var.private_dns_zone_group.private_dns_zone : (
      instance.id == null ? (
        instance.name == null ? (
          var.dns_zones[instance.key].id
        ) : data.azurerm_dns_zone.this[instance.name].id
      ) : instance.id
    )]
  }

  # TODO , add lookup for private connection resource id
  # Currently using hardcoded resource type to generate resource ID strings.
  private_service_connection = var.private_service_connection == null ? null : {
    name                 = var.private_service_connection.name
    is_manual_connection = var.private_service_connection.is_manual_connection
    private_connection_resource_id = var.private_service_connection.private_connection_resource == null ? null : (
      var.private_service_connection.private_connection_resource.id == null ? (
        "/subscriptions/${local.subscription_id}/resourceGroups/${coalesce(var.private_service_connection.private_connection_resource.resource_group_name, local.resource_group_name)}/providers/${var.private_service_connection.private_connection_resource.baseResourceType}/${var.private_service_connection.private_connection_resource.name}"
      ) : var.private_service_connection.private_connection_resource.id
    )
    private_connection_resource_alias = var.private_service_connection.private_connection_resource_alias
    subresource_name                  = var.private_service_connection.subresource_name
    request_message                   = var.private_service_connection.request_message
  }
}