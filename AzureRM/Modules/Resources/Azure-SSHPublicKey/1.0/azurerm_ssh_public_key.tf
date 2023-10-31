resource "azurerm_ssh_public_key" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  public_key          = local.public_key
  tags                = local.tags
}