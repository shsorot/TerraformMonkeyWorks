output "id" {
  value = azurerm_dedicated_host_group.this.id
  description = "The ID of the Dedicated Host Group."
}

output "name" {
  value = azurerm_dedicated_host_group.this.name
  description = "The name of the Dedicated Host Group."
}

output "platform_fault_domain" {
  value = var.platform_fault_domain_count
  description = "The number of fault domains that the Dedicated Host Group spans."
}