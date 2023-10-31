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

# Data block for User assigned identity
# TODO: fix this code, this is broken
data "azurerm_user_assigned_identity" "this" {
  for_each = { for instance in local.user_assigned_identities : instance.name => instance if (instance.name == null ? false : true) }
  name                = each.value.name
  resource_group_name = coalesce(each.value.resource_group_name, local.resource_group_name)
}

data "azurerm_key_vault" "this"{
  count = var.encryption == null || var.encryption == {} ? 0 : (var.encryption.key_vault_key.key_vault_name == null && var.encryption.key_vault_key.name == null ? 0 : 1)
  name = var.encryption.key_vault_key.key_vault_name
  resource_group_name = coalesce(local.resource_group_name, var.encryption.key_vault_key.resource_group_name)
}

data "azurerm_key_vault_key" "this" {
  count = var.encryption == null || var.encryption == {} ? 0 : (var.encryption.key_vault_key.key_vault_name == null && var.encryption.key_vault_key.name == null ? 0 : 1)
  name = var.encryption.key_vault_key.name
  key_vault_id = data.azurerm_key_vault.this[0].id
}

locals {
  identity_user_assigned_identity = var.identity == null || var.identity == {} ? [] : (var.identity.identity == [] || var.identity.identity == null ? [] : var.identity.identity)
  encryption_user_assigned_identity = var.encryption == null || var.encryption == {} ? [] : (var.encryption.user_assigned_identity == {} || var.encryption.user_assigned_identity == null ? [] : [var.encryption.user_assigned_identity])
  user_assigned_identities = distinct(concat(local.identity_user_assigned_identity,local.encryption_user_assigned_identity ))

  identity = var.identity == null || var.identity == {} ? null : {
    type = var.identity.type
    # Create a list of managed identities.
    identity_ids = var.identity.type == "UserAssigned" || var.identity.type == "SystemAssigned, UserAssigned" ? (
      [for instance in var.identity.identity : (
        instance.id == null ? (
          instance.name == null ? (
            var.user_assigned_identities[instance.key].id
          ) : data.azurerm_user_assigned_identity.this[instance.name].id
        ) : instance.id
      )]
    ) : null
  }

  encryption = var.encryption == null || var.encryption == {} ? null : {
    user_assigned_identity_id = var.encryption.user_assigned_identity == null || var.encryption.user_assigned_identity == {} ? null : (
      var.encryption.user_assigned_identity.id == null ? (
        var.encryption.user_assigned_identity.name == null ? (
           var.user_assigned_identities[var.encryption.user_assigned_identity.name].id
        ) : data.azurerm_user_assigned_identity.this[var.encryption.user_assigned_identity.name].id
      ) : var.encryption.user_assigned_identity.id
    )
    key_source = try(var.encryption.key_source,"Microsoft.Keyvault")
    key_vault_key_id = var.encryption.key_vault_key.id == null ? (
      var.encryption.key_vault_key.name == null && var.encryption.key_vault_key.resource_group_name == null ? (
        var.key_vault_keys[var.encryption.key_vault_key.key].id
      ) : data.azurerm_key_vault_key.this[0].id
    ) : var.encryption.key_vault_key.id
  }
}