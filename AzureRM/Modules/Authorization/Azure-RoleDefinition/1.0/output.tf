output "name"{
  value = azurerm_role_definition.this.name
  description = "Name of the role definition ID."
}

output "id" {
  value      = azurerm_role_definition.this.id
  description = "This ID is specific to Terraform - and is of the format {roleDefinitionId}|{scope}."
}

output "role_definition_id" {
  value       = azurerm_role_definition.this.role_definition_id
  description = "The Role Definition ID."
}

output "role_definition_resource_id" {
  value       = azurerm_role_definition.this.role_definition_id
  description = "The Azure Resource Manager ID for the resource."
}