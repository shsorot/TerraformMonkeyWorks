resource "azurerm_lb_outbound_rule" "this" {
  for_each = { for instance in(var.loadbalancer_outbound_rule == null ? [] : var.loadbalancer_outbound_rule) : instance.name => instance }

  name                = each.key
  # resource_group_name = local.resource_group_name
  loadbalancer_id     = azurerm_lb.this.id
  dynamic "frontend_ip_configuration" {
    #count     = each.value.frontend_ip_configuration_name == null ? [] : each.value.frontend_ip_configuration_name
    for_each = { for entry in each.value.frontend_ip_configuration_name : entry => entry }
    content {
      name = frontend_ip_configuration.key
    }
  }

  backend_address_pool_id  = azurerm_lb_backend_address_pool.this[each.value.backend_address_pool_name].id
  protocol                 = coalesce(each.value.protocol, "Tcp")
  enable_tcp_reset         = each.value.enable_tcp_reset
  allocated_outbound_ports = each.value.allocated_outbound_ports
  idle_timeout_in_minutes  = each.value.idle_timeout_in_minutes == null ? 4 : each.value.idle_timeout_in_minutes
}
