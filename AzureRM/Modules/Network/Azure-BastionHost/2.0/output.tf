output "id" {
  value = azurerm_bastion_host.this.id
}

output "fqdn" {
  value = azurerm_bastion_host.this.dns_name
}

output "public_ip" {
  value = {
    "id"         = azurerm_public_ip.this.id
    "ip_address" = azurerm_public_ip.this.ip_address
    "fqdn"       = azurerm_public_ip.this.fqdn
  }
}

output "subnet" {
  value = {
    "id"                   = azurerm_subnet.this.id
    "name"                 = azurerm_subnet.this.name
    "virtual_network_name" = azurerm_subnet.this.virtual_network_name
    "address_prefixes"     = azurerm_subnet.this.address_prefixes
  }
}