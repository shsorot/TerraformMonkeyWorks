resource "azurerm_virtual_machine_extension" "addsdomainjoin" {
  name                       = "domain-join"
  virtual_machine_id         = local.virtual_machine_id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true
  tags                       = local.tags
  settings                   = local.settings
  protected_settings         = local.protected_settings
}