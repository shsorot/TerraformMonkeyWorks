resource "azurerm_subnet_route_table_association" "this" {
  subnet_id      = local.subnet_id
  route_table_id = local.route_table_id
}