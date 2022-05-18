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

# Data block for User assigned identity
data "azurerm_user_assigned_identity" "this" {
  for_each            = var.identity == null ? null : ( var.identity.type == "UserAssignedIdentity" || var.identity.type == "SystemAssigned, UserAssigned" ? {
                          for instance in var.identity.identity : instance.name => instance if instance.name != null
                        } : null )
  name                = each.value.name
  resource_group_name = coalesce(each.value.resource_group_name,local.resource_group_name)
}

locals {
  identity = var.identity == null || var.identity == {} ? null : {
    type = var.identity.type
    # Create a list of managed identities.
    identity_ids = var.identity.type == "UserAssigned" || var.identity.type == "SystemAssigned, UserAssigned" ? (
        [for instance in var.identity.identity :(
          instance.id == null ? (
            instance.name == null ? (
              var.user_assigned_identities[instance.tag].id
            ) : data.azurerm_user_assigned_identity.this[instance.name].id
          ) : instance.id
        )]
    ) : null
  }
}