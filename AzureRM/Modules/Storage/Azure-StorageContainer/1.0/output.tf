output "id" {
  value = azurerm_storage_container.this.id
}

output "has_immutability_policy" {
  value = azurerm_storage_container.this.has_immutability_policy
}

output "has_legal_hold" {
  value = azurerm_storage_container.this.has_legal_hold
}

output "resource_manager_id" {
  value = azurerm_storage_container.this.resource_manager_id
}