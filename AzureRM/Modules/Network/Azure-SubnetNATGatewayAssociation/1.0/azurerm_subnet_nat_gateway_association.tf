resource "azurerm_subnet_nat_gateway_association" "this" {
  nat_gateway_id = local.nat_gateway_id
  subnet_id      = local.subnet_id
}