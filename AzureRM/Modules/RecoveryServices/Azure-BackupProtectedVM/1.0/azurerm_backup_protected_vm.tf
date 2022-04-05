resource "azurerm_backup_protected_vm" "this" {
  resource_group_name = local.resource_group_name
  recovery_vault_name = local.recovery_vault_name
  source_vm_id        = local.source_vm_id
  backup_policy_id    = local.backup_policy_id
  # Deprecated from provider > 3.00.0
  # tags                = local.tags
}