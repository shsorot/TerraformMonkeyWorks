resource "azurerm_lb_backend_address_pool" "this" {
  for_each        = { for s in(var.backend_address_pool == null ? [] : var.backend_address_pool) : s => azurerm_lb.this.id }
  name            = each.key
  loadbalancer_id = each.value
  depends_on      = [azurerm_lb.this]
}
