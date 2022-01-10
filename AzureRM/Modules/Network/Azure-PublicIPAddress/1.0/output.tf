output "id" {
  value = azurerm_public_ip.this.id

}

output "address" {
  value = azurerm_public_ip.this.ip_address

}

output "fqdn" {
  value = azurerm_public_ip.this.fqdn

}