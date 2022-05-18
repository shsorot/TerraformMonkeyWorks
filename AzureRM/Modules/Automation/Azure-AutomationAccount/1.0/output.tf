output "id" {
  description = "The Automation Account ID."
  value       = azurerm_automation_account.this.id
}

output "name" {
  description = "The Automation Account name."
  value       = azurerm_automation_account.this.name
}

output "dsc_server_endpoint" {
  value = azurerm_automation_account.this.dsc_server_endpoint
}

output "dsc_primary_access_key" {
  value = azurerm_automation_account.this.dsc_primary_access_key
  sensitive = true
}

output "dsc_secondary_access_key" {
  value = azurerm_automation_account.this.dsc_secondary_access_key
  sensitive = true
}

