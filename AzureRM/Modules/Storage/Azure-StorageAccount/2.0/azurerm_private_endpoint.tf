resource "azurerm_private_endpoint"{
  count = local.private_endpoints
}