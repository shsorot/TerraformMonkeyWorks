resource "azurerm_log_analytics_cluster" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  identity {
    type = var.identity.type
  }
  size_gb = var.size_gb
  tags    = local.tags
}