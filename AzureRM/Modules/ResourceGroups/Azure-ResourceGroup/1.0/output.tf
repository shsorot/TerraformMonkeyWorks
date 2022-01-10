output "id" {
  value = azurerm_resource_group.this.id
}

output "name" {
  value = var.name
}


output "management_lock" {
  value       = { "id" = azurerm_management_lock.this.*.id }
  description = "Resource ID of the management lock."

}

output "tags" {
  value = var.tags
}

output "location" {
  value = var.location
}