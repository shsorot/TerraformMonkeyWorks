output "id" {
  value       = azurerm_local_network_gateway.this.id
  description = "The ID of the Local Network Gateway."
}

output "name" {
  value = azurerm_local_network_gateway.this.name
}

output "resource_group_name" {
  value = azurerm_local_network_gateway.this.resource_group_name
}

output "location" {
  value = azurerm_local_network_gateway.this.location
}