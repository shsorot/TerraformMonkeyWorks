output "id" {
  value = azurerm_virtual_network_gateway.this.id
}

output "bgp_settings" {
  value = azurerm_virtual_network_gateway.this.bgp_settings
}