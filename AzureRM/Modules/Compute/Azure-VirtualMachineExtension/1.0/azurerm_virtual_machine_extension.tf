resource "azurerm_virtual_machine_extension" "this" {
  name                       = var.name
  virtual_machine_id         = local.virtual_machine_id
  publisher                  = var.publisher
  type                       = var.type
  type_handler_version       = var.type_handler_version
  auto_upgrade_minor_version = var.auto_upgrade_minor_version
  settings                   = local.settings
  protected_settings         = local.protected_settings
  tags                       = local.tags
}