# <TODO> To add a local data lookup for express route circuit peering when enabled by Terraform Azure provider
resource "azurerm_express_route_circuit_connection" "this" {
  name                = var.name
  peering_id          = local.peering_id
  peer_peering_id     = local.peer_peering_id
  address_prefix_ipv4 = var.address_prefix_ipv4
  authorization_key   = var.authorization_key
  address_prefix_ipv6 = var.address_prefix_ipv6
}