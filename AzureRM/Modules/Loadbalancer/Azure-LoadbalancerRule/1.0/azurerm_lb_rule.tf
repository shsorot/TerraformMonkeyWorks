resource "azurerm_lb_rule" "this" {
  name                           = var.name
  # resource_group_name            = local.resource_group_name
  loadbalancer_id                = local.loadbalancer_id
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
  protocol                       = var.protocol
  frontend_port                  = var.frontend_port
  backend_port                   = var.backend_port
  # <TODO> This is being deprecated. Change this ASAP.
  backend_address_pool_ids = local.backend_address_pool_ids
  probe_id                = local.probe_id
  enable_floating_ip      = var.enable_floating_ip
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  load_distribution       = var.load_distribution
  disable_outbound_snat   = var.disable_outbound_snat
  enable_tcp_reset        = var.enable_tcp_reset
}