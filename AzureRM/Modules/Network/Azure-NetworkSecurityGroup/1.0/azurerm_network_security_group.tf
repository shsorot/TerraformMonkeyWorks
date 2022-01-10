resource "azurerm_network_security_group" "this" {
  tags                = local.tags
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
}
