output "name" {
  value       = azurerm_availability_set.this.name
  description = "The name of the Availability Set."
}

output "id" {
  value       = azurerm_availability_set.this.id
  description = "The ID of the Availability Set."
}

output "platform_fault_domain_count" {
  value       = azurerm_availability_set.this.platform_fault_domain_count
  description = "Value of platform_fault_domain_count"
}

output "platform_update_domain_count" {
  value       = azurerm_availability_set.this.platform_update_domain_count
  description = "Value of platform_update_domain_count"
}