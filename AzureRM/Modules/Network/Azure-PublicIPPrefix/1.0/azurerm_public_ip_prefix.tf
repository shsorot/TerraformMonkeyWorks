
resource "azurerm_public_ip_prefix" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  sku                 = var.sku
  prefix_length       = var.prefix_length
  # availability_zone   = var.availability_zone
  zones = var.zones
  tags  = local.tags
}