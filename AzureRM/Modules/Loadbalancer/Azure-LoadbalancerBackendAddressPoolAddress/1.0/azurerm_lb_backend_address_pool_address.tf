resource "azurerm_lb_backend_address_pool_address" "this" {
  backend_address_pool_id = local.backend_address_pool_id
  ip_address              = var.ip_address
  name                    = var.name
  virtual_network_id      = local.virtual_network_id
}