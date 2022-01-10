resource "azurerm_network_interface_backend_address_pool_association" "this" {
  network_interface_id    = local.network_interface_id
  ip_configuration_name   = var.ip_configuration_name
  backend_address_pool_id = local.backend_address_pool_id
}