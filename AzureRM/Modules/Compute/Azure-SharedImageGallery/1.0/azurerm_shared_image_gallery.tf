resource "azurerm_shared_image_gallery" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  description         = var.description
  tags                = local.tags
}