resource "azurerm_disk_encryption_set" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags
  key_vault_key_id    = local.key_vault_key_id

  identity {
    type = var.identity.type == null ? "SystemAssigned" : var.identity.type
  }

}