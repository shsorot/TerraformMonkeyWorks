resource "azurerm_nat_gateway" "this" {
  name                    = var.name
  resource_group_name     = local.resource_group_name
  location                = local.location
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  sku_name                = var.sku_name
  tags                    = local.tags
  zones                   = var.zones
}