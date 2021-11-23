
resource "azurerm_lb_nat_pool" "this" {
  for_each                       = { for instance in(var.loadbalancer_nat_pool == null ? [] : var.loadbalancer_nat_pool) : instance.name => instance }
  name                           = each.key
  resource_group_name            = local.resource_group_name
  loadbalancer_id                = azurerm_lb.this.id
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  protocol                       = coalesce(each.value["lb_protocol"], "Tcp")
  frontend_port_start            = each.value.frontend_port_start
  frontend_port_end              = each.value.frontend_port_end
  backend_port                   = each.value.backend_port
}
