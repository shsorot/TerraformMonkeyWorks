output "id" {
  value = azurerm_backup_policy_vm.this.id
}

output "name" {
  value = azurerm_backup_policy_vm.this.name
}

output "recovery_vault_name" {
  value = local.recovery_vault_name
}

output "resource_group_name" {
  value = local.resource_group_name
}