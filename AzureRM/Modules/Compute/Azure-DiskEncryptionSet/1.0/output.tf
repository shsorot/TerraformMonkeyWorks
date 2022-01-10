output "id" {
  value = azurerm_disk_encryption_set.this.id
}

output "name" {
  value = azurerm_disk_encryption_set.this.name
}

output "identity" {
  value = azurerm_disk_encryption_set.this.identity[0]
}