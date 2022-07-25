# Network Security Group association to Subnets
# TODO: Test data based lookup
resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = local.security_groups
  network_security_group_id = each.value.network_security_group_id
  subnet_id = azurerm_subnet.this[each.key].id
}