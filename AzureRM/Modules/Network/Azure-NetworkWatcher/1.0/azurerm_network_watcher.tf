resource "azurerm_network_watcher" "this" {
  name                = var.network_watcher_name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags
}