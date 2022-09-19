# TODO : Add data block based lookup
resource "azurerm_network_interface_security_group_association" "this" {
  count                = try(var.network_security_group, null) == null ? 0 : 1
  network_interface_id = azurerm_network_interface.this.id
  network_security_group_id = local.network_security_group_id
}


