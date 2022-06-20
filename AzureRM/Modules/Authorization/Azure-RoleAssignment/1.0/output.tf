output "id" {
  value       = azurerm_role_assignment.this.id
  description = "The Role Assignment ID."
}

output "principal_type" {
  value       = azurerm_role_assignment.this.principal_type
  description = "The type of the principal_id, e.g. User, Group, Service Principal, Application, etc."
}

output "name" {
  value       = azurerm_role_assignment.this.name
  description = "The name of the Role Assignment."
}

