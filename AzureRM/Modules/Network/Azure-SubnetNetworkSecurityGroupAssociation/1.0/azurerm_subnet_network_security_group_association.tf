resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = local.subnet_id
  network_security_group_id = local.network_security_group_id
}


