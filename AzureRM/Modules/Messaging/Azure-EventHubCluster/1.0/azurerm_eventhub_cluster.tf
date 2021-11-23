resource "azurerm_eventhub_cluster" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  sku_name            = var.sku_name
  tags                = local.tags
}