output "local_id" {
  description = "The ID of the Virtual Network Peering."
  value       = azurerm_virtual_network_peering.local.id
}

output "remote_id" {
  description = "The ID of the Virtual Network Peering."
  value       = azurerm_virtual_network_peering.remote.id
}