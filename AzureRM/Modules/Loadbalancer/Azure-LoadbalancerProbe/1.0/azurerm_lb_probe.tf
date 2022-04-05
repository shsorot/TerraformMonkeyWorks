resource "azurerm_lb_probe" "this" {
  name                = var.name
  # Deprecated from provider > 3.00.0
  # resource_group_name = local.resource_group_name
  loadbalancer_id     = local.loadbalancer_id
  protocol            = var.protocol
  port                = var.port
  request_path        = var.request_path
  interval_in_seconds = var.interval_in_seconds
  number_of_probes    = var.number_of_probes
}