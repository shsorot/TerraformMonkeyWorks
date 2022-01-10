resource "azurerm_resource_group" "this" {
  tags     = var.tags
  name     = var.name
  location = var.location
}