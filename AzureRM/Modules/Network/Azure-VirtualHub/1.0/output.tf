output "id" {
  value = azurerm_virtual_hub.this.id
}

output "name" {
  value = azurerm_virtual_hub.this.name
}

output "resource_group_name" {
  value = azurerm_virtual_hub.this.resource_group_name
}

output "address_prefix" {
  value = azurerm_virtual_hub.this.address_prefix
}

# Conflict with Terraform documentation and actual API
#output "default_route_table_id" {
#  value = azurerm_virtual_hub.this.default_route_table_id
#}

output "route_tables" {
  value = var.route
}

