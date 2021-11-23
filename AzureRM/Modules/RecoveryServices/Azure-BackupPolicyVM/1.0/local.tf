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
}

data "azurerm_recovery_services_vault" "this" {
  count               = var.recovery_vault.name != null ? 1 : 0
  name                = var.recovery_vault.name
  resource_group_name = local.resource_group_name
}

locals {
  recovery_vault_name = var.recovery_vault.name == null ? (
    var.recovery_vaults[var.recovery_vault.tag].name
  ) : data.azurerm_recovery_services_vault.this[0].name
}