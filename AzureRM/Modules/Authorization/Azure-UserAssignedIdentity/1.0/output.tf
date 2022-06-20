output "id" {
  value       = azurerm_user_assigned_identity.this.id
  description = "The user assigned identity ID."
}

output "principal_id" {
  value       = azurerm_user_assigned_identity.this.principal_id
  description = "Service Principal ID associated with the user assigned identity."
}

output "tenant_id" {
  value       = azurerm_user_assigned_identity.this.tenant_id
  description = "Tenant ID associated with the user assigned identity."
}

output "client_id" {
  value       = azurerm_user_assigned_identity.this.client_id
  description = "Client ID associated with the user assigned identity."
}