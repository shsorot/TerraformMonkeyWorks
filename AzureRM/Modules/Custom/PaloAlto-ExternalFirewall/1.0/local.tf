# This file contains local & data blocks
data "azurerm_subscription" "current" {
}


data "azurerm_resource_group" "this" {
  count = var.resource-group.name == null ? 0 : 1
  name  = var.resource-group.name
}

data "azurerm_backup_policy_vm" "this" {
  count               = var.backup_policy.name == null && var.backup_policy.resource_group_name == null && var.backup_policy.recovery_vault_name == null ? 0 : 1
  name                = var.backup_policy.name
  recovery_vault_name = var.backup_policy.recovery_vault_name
  resource_group_name = var.backup_policy.resource_group_name
}


#Create the local variables
locals {
  subscription_id = data.azurerm_subscription.current.subscription_id

  resource_group_tags     = var.resource-group.name == null ? var.resource_groups[var.resource-group.tag].tags : data.azurerm_resource_group.this[0].tags
  tags                    = merge(var.tags, (var.inherit_tags == true ? local.resource_group_tags : {}))
  resource_group_location = var.resource-group.name == null ? var.resource_groups[var.resource-group.tag].location : data.azurerm_resource_group.this[0].location
  location                = var.location == null ? local.resource_group_location : var.location

  resource_group_name                 = var.resource-group.name == null ? var.resource_groups[var.resource-group.tag].name : data.azurerm_resource_group.this[0].name
  virtual-machine-resource-group-name = local.resource_group_name

  key-vault-id = var.keyvault.id == null ? var.keyvaults[var.keyvault.tag].id : var.keyvault.id

  virtual-network-id  = var.virtual-network.id == null ? var.virtual_networks[var.virtual-network.tag].id : var.virtual-network.id
  mgmt-subnet-id      = "${local.virtual-network-id}/subnets/${var.mgmt-subnet-name}"
  untrusted-subnet-id = "${local.virtual-network-id}/subnets/${var.untrusted-subnet-name}"
  trusted-subnet-id   = "${local.virtual-network-id}/subnets/${var.trusted-subnet-name}"

  load-balancer-id                                      = var.trusted-internal-loadbalancer.id == null ? var.loadbalancers[var.trusted-internal-loadbalancer.tag].id : var.trusted-internal-loadbalancer.id
  trusted-internal-loadbalancer-backend-address-pool-id = "${local.load-balancer-id}/backendAddressPools/${var.trusted-internal-loadbalancer-backend-address-pool-name}"
  admin-password                                        = var.admin-password == null || var.admin-password == "" ? random_password.credential-value.result : var.admin-password
  backup_policy_id = var.backup_policy.name == null && var.backup_policy.resource_group_name == null && var.backup_policy.recovery_vault_name == null ? (
    var.backup_policies[var.backup_policy.tag].id
  ) : data.azurerm_backup_policy_vm.this[0].id
  recovery_vault_name = var.backup_policy.name == null && var.backup_policy.resource_group_name == null && var.backup_policy.recovery_vault_name == null ? (
    var.backup_policies[var.backup_policy.tag].recovery_vault_name
  ) : data.azurerm_backup_policy_vm.this[0].recovery_vault_name

  recovery_vault_resource_group_name = var.backup_policy.name == null && var.backup_policy.resource_group_name == null && var.backup_policy.recovery_vault_name == null ? (
    var.backup_policies[var.backup_policy.tag].resource_group_name
  ) : data.azurerm_backup_policy_vm.this[0].resource_group_name
}
