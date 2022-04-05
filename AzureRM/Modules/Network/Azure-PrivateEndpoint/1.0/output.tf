output "id" {
  value = azurerm_private_endpoint.this.id
}

output "network_interface" {
  value = azurerm_private_endpoint.this.network_interface
}

output "private_dns_zone_group" {
  value = azurerm_private_endpoint.this.private_dns_zone_group
}

output "custom_dns_configs" {
  value = azurerm_private_endpoint.this.custom_dns_configs
}

output "private_dns_zone_configs" {
  value = azurerm_private_endpoint.this.private_dns_zone_configs
}