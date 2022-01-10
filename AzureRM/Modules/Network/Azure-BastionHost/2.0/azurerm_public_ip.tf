resource "azurerm_public_ip" "this" {
  name                = var.public_ip_address.name
  location            = local.location
  resource_group_name = var.public_ip_address.resource_group_name == null ? local.resource_group_name : var.public_ip_address.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}