output "name" {
  value = azurerm_availability_set.this.name
}

output "id" {
  value = azurerm_availability_set.this.id
}

output "platform_fault_domain_count" {
  value = azurerm_availability_set.this.platform_fault_domain_count
}

output "platform_update_domain_count" {
  value = azurerm_availability_set.this.platform_update_domain_count
}