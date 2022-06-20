resource "azurerm_lb_probe" "this" {
  for_each = { for instance in(var.probe == null ? [] : var.probe) : instance.name => instance }
  name     = each.key
  # Deprecated from provider > 3.00.0
  # resource_group_name = local.resource_group_name
  loadbalancer_id     = azurerm_lb.this.id
  port                = each.value.probe_port
  protocol            = lookup(each.value, "probe_protocol", null)
  request_path        = lookup(each.value, "probe_protocol", null) == "Tcp" ? null : lookup(each.value, "request_path", null)
  interval_in_seconds = lookup(each.value, "probe_interval", null)
  number_of_probes    = lookup(each.value, "probe_unhealthy_threshold", null)
  depends_on          = [azurerm_lb.this]
}

