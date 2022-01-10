output "id" {
  value = azurerm_private_dns_zone.this.id
}

# output "fqdn" {
#     value   =   azurerm_private_dns_zone.this.fqdn
# }


# output "host_name" {
#     value   =   azurerm_private_dns_zone.this.host_name
# }

# output "serial_number" {
#     value   =   azurerm_private_dns_zone.this.serial_number
# }

output "number_of_record_sets" {
  value = azurerm_private_dns_zone.this.number_of_record_sets
}

output "max_number_of_record_sets" {
  value = azurerm_private_dns_zone.this.max_number_of_record_sets
}

output "max_number_of_virtual_network_links" {
  value = azurerm_private_dns_zone.this.max_number_of_virtual_network_links
}

output "max_number_of_virtual_network_links_with_registration" {
  value = azurerm_private_dns_zone.this.max_number_of_virtual_network_links_with_registration
}
