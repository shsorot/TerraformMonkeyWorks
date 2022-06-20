resource "azurerm_disk_encryption_set" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags
  key_vault_key_id    = local.key_vault_key_id
  # Added in provider > 3.xx.x
  auto_key_rotation_enabled = var.auto_key_rotation_enabled
  encryption_type           = var.encryption_type

  # Currently only possible type is "SystemAssigned", but code left to accomodate future changes.
  identity {
    type = var.identity.type == null ? "SystemAssigned" : var.identity.type
  }

}