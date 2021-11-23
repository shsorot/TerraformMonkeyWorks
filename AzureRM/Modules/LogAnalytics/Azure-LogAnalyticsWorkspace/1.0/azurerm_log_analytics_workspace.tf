resource "azurerm_log_analytics_workspace" "this" {
  name                       = var.name
  resource_group_name        = local.resource_group_name
  location                   = local.location
  sku                        = var.sku
  retention_in_days          = var.retention_in_days
  daily_quota_gb             = var.daily_quota_gb
  internet_ingestion_enabled = var.internet_ingestion_enabled
  tags                       = local.tags
}