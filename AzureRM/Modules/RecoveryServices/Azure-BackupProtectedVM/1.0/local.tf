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
  location                = local.resource_group_location
}

data "azurerm_backup_policy_vm" "this" {
  count               = var.backup_policy.name == null ? 0 : 1
  name                = var.backup_policy.name
  recovery_vault_name = var.recovery_vault_name
  resource_group_name = local.resource_group_name
}

data "azurerm_virtual_machine" "this" {
  count               = var.source_vm.name == null ? 0 : 1
  name                = var.source_vm.name
  resource_group_name = var.source_vm.resource_group_name == null ? local.resource_group_name : var.source_vm.resource_group_name
}

locals {
  source_vm_id = var.source_vm.id == null ? (
    var.source_vm.name == null ? (
      var.virtual_machines[var.source_vm.key].id
    ) : data.azurerm_virtual_machine.this[0].id
  ) : var.source_vm.id

  recovery_vault_name = var.recovery_vault_name
  backup_policy_id = var.backup_policy.id == null ? (
    var.backup_policy.name == null ? (
      var.backup_policies[var.backup_policy.key].id
    ) : data.azurerm_backup_policy_vm.this[0].id
  ) : var.backup_policy.id
}