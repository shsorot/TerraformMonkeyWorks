output "id" {
  value = azurerm_dedicated_host_group.this.id
}

output "name" {
  value = azurerm_dedicated_host_group.this.name
}

output "platform_fault_domain" {
  value = var.platform_fault_domain_count
}