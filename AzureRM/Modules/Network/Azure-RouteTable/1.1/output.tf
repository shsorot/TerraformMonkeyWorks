output "id" {
  value = azurerm_route_table.this.id
}

output "subnets" {
  value = azurerm_route_table.this.subnets
}

output "name" {
  value = azurerm_route_table.this.name
}

output "route" {
  value = var.route
}