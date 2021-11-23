output "id" {
  value = azurerm_subnet.this.id
}

output "name" {
  value = azurerm_subnet.this.id
}

/*
output "virtual_network_subnet_ids" {
  value = { for x in azurerm_subnet.this : x.name => x.id }
}
*/