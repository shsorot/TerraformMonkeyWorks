resource "azurerm_lb_rule" "this" {
  for_each                       = { for instance in(var.loadbalancer_rule == null ? [] : var.loadbalancer_rule) : instance.name => instance }
  name                           = each.key
  # Deprecated from provider > 3.00.0
  # resource_group_name            = local.resource_group_name
  loadbalancer_id                = azurerm_lb.this.id
  protocol                       = coalesce(each.value.protocol, "Tcp")
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  # TODO : add code for dual pool ids when lb type is gateway
  
  backend_address_pool_ids       = each.value.backend_address_pool_name == null ? null : [azurerm_lb_backend_address_pool.this[each.value.backend_address_pool_name].id]
  probe_id                       = each.value.probe_name == null ? null : azurerm_lb_probe.this[each.value.probe_name].id
  idle_timeout_in_minutes        = each.value.idle_timeout_in_minutes == null ? 4 : each.value.idle_timeout_in_minutes
  depends_on                     = [azurerm_lb.this, azurerm_lb_backend_address_pool.this, azurerm_lb_probe.this]
}
