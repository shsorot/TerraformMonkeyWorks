resource "azurerm_nat_gateway_public_ip_association" "this" {
  nat_gateway_id       = local.nat_gateway_id
  public_ip_address_id = local.public_ip_address_id
}