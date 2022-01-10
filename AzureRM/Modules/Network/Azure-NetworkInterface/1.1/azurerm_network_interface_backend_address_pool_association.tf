resource "azurerm_network_interface_backend_address_pool_association" "this" {
  count                   = local.load_balanced_ip_configuration == null ? 0 : length(local.load_balanced_ip_configuration)
  network_interface_id    = azurerm_network_interface.this.id
  ip_configuration_name   = local.load_balanced_ip_configuration[count.index].ip_configuration_name
  backend_address_pool_id = local.load_balanced_ip_configuration[count.index].backend_address_pool_id
}
