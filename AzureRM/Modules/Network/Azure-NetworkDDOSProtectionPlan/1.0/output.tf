output "id" {
  value       = azurerm_network_ddos_protection_plan.this.id
  description = "The ID of the DDoS Protection Plan"
}

output "virtual_network_id" {
  value       = azurerm_network_ddos_protection_plan.this.virtual_network_ids
  description = "A list of Virtual Network ID's associated with the DDoS Protection Plan."
}