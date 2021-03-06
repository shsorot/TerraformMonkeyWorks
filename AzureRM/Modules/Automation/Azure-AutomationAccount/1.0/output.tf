output "id" {
  description = "The Automation Account ID."
  value       = azurerm_automation_account.this.id
}

output "name" {
  description = "The Automation Account name."
  value       = azurerm_automation_account.this.name
}

output "location" {
  value       = local.location
  description = "Location of the resource."
}

output "resource_group_name" {
  value       = local.resource_group_name
  description = "Resource Group of the resource."
}

output "dsc_server_endpoint" {
  value       = azurerm_automation_account.this.dsc_server_endpoint
  description = "The DSC Server Endpoint associated with this Automation Account."
}

output "dsc_primary_access_key" {
  value       = azurerm_automation_account.this.dsc_primary_access_key
  description = "The Primary Access Key for the DSC Endpoint associated with this Automation Account."
  sensitive   = true
}

output "dsc_secondary_access_key" {
  value       = azurerm_automation_account.this.dsc_secondary_access_key
  description = "The Secondary Access Key for the DSC Endpoint associated with this Automation Account."
  sensitive   = true
}

