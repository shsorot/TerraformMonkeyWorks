resource "azurerm_netapp_account" "this" {
  name                = var.name
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = local.tags

  # Single Block
  dynamic "active_directory" {
    for_each = var.active_directory == null ? [] : [1]
    content {
      dns_servers         = var.active_directory.dns_servers
      domain              = var.active_directory.domain
      smb_server_name     = var.active_directory.smb_server_name
      username            = var.active_directory.username
      password            = var.active_directory.password
      organizational_unit = var.active_directory.organizational_unit
    }
  }
}