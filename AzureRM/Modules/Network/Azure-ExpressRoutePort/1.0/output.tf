output "id" {
  value = azurerm_express_route_port.this.id
}

output "identity" {
  value = azurerm_express_route_port.this.identity
}

# Incorrect Terraform provider documentation
#output "link" {
#  value = azurerm_express_route_port.this.link
#}

output "guid" {
  value = azurerm_express_route_port.this.guid
}

output "ethertype" {
  value = azurerm_express_route_port.this.ethertype
}

output "mtu" {
  value = azurerm_express_route_port.this.mtu
}