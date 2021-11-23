output "id" {
  value = azurerm_express_route_circuit_peering.this.id
}

output "azure_asn" {
  value = azurerm_express_route_circuit_peering.this.azure_asn
}

output "primary_azure_port" {
  value = azurerm_express_route_circuit_peering.this.primary_azure_port
}

output "secondary_azure_port" {
  value = azurerm_express_route_circuit_peering.this.secondary_azure_port
}