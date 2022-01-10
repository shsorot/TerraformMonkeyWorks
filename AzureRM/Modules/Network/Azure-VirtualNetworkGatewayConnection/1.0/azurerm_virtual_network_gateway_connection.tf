resource "azurerm_virtual_network_gateway_connection" "this" {
  name                               = var.name
  resource_group_name                = local.resource_group_name
  location                           = local.location
  tags                               = local.tags
  type                               = var.type
  virtual_network_gateway_id         = local.virtual_network_gateway_id
  authorization_key                  = var.authorization_key
  dpd_timeout_seconds                = var.dpd_timeout_seconds
  express_route_circuit_id           = local.express_route_circuit_id
  peer_virtual_network_gateway_id    = local.peer_virtual_network_gateway_id
  local_azure_ip_address_enabled     = var.local_azure_ip_address_enabled
  local_network_gateway_id           = local.local_network_gateway_id
  routing_weight                     = var.routing_weight
  shared_key                         = var.shared_key
  connection_protocol                = var.connection_protocol
  enable_bgp                         = var.enable_bgp
  express_route_gateway_bypass       = var.express_route_gateway_bypass
  use_policy_based_traffic_selectors = var.use_policy_based_traffic_selectors

  dynamic "ipsec_policy" {
    for_each = var.ipsec_policy == null ? [] : [1]
    content {
      dh_group         = var.ipsec_policy.dh_group
      ike_encryption   = var.ipsec_policy.ike_encryption
      ike_integrity    = var.ipsec_policy.ike_integrity
      ipsec_encryption = var.ipsec_policy.ipsec_encryption
      ipsec_integrity  = var.ipsec_policy.ipsec_integrity
      pfs_group        = var.ipsec_policy.pfs_group
      sa_datasize      = var.ipsec_policy.sa_datasize
      sa_lifetime      = var.ipsec_policy.sa_lifetime
    }
  }

  dynamic "traffic_selector_policy" {
    for_each = var.traffic_selector_policy == null ? [] : [1]
    content {
      local_address_cidrs  = var.traffic_selector_policy.local_address_cidrs
      remote_address_cidrs = var.traffic_selector_policy.remote_address_cidrs
    }
  }
}