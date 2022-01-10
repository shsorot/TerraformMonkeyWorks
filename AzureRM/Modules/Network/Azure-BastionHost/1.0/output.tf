output "id" {
  value = azurerm_bastion_host.this.id
}

output "fqdn" {
  value = azurerm_bastion_host.this.dns_name
}