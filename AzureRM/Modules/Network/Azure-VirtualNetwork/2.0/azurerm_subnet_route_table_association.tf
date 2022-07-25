
# Route Table association to Subnets
# TODO: test data based lookup
resource "azurerm_subnet_route_table_association" "this" {
  for_each = local.route_tables
  route_table_id = each.value.route_table_id
  subnet_id = azurerm_subnet.this[each.key].id
}