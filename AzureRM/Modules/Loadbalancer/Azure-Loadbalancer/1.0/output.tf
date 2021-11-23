output "id" {
  value = azurerm_lb.this.id
}

output "frontend_ip_configuration" {
  value = azurerm_lb.this.frontend_ip_configuration
}

output "private_ip_address" {
  value = azurerm_lb.this.private_ip_address
}

output "private_ip_addresses" {
  value = azurerm_lb.this.private_ip_addresses
}