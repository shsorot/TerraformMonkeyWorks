resource "azurerm_lb_nat_rule" "this" {
  for_each                       = { for instance in(var.loadbalancer_nat_rule == null ? [] : var.loadbalancer_nat_rule) : instance.name => instance }
  name                           = each.key
  resource_group_name            = local.resource_group_name
  loadbalancer_id                = azurerm_lb.this.id
  protocol                       = coalesce(each.value.protocol, "Tcp")
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  idle_timeout_in_minutes        = each.value.idle_timeout_in_minutes == null ? 4 : each.value.idle_timeout_in_minutes
  enable_floating_ip             = each.value.enable_floating_ip == null ? false : each.value.enable_floating_ip
  enable_tcp_reset               = each.value.enable_tcp_reset == null ? false : each.value.enable_tcp_reset
}

