resource "azurerm_recovery_services_vault" "this" {
  tags                = local.tags
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  sku                 = var.sku
  soft_delete_enabled = var.soft_delete_enabled

  identity {
    type = var.identity_type
  }
}