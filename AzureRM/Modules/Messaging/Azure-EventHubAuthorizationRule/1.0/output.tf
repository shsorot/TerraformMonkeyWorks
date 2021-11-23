output "id" {
  value = azurerm_eventhub_authorization_rule.this.id
}

output "primary_connection_string_alias" {
  value = azurerm_eventhub_authorization_rule.this.primary_connection_string_alias
}

output "secondary_connection_string_alias" {
  value = azurerm_eventhub_authorization_rule.this.secondary_connection_string_alias
}

output "primary_connection_string" {
  value = azurerm_eventhub_authorization_rule.this.primary_connection_string
}

output "primary_key" {
  value     = azurerm_eventhub_authorization_rule.this.primary_key
  sensitive = true
}

output "secondary_connection_string" {
  value = azurerm_eventhub_authorization_rule.this.secondary_connection_string
}

output "secondary_key" {
  value     = azurerm_eventhub_authorization_rule.this.secondary_key
  sensitive = true
}

