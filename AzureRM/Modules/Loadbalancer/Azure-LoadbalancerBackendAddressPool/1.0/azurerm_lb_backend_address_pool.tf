resource "azurerm_lb_backend_address_pool" "this" {
  name            = var.name
  loadbalancer_id = local.loadbalancer_id
}