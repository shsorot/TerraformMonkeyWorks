output "id" {
  value = azurerm_log_analytics_workspace.this.id
}

output "primary_shared_key" {
  value     = azurerm_log_analytics_workspace.this.primary_shared_key
  sensitive = true
}

output "secondary_shared_key" {
  value     = azurerm_log_analytics_workspace.this.secondary_shared_key
  sensitive = true
}

output "workspace_id" {
  value = azurerm_log_analytics_workspace.this.workspace_id
}