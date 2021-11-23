output "id" {
  value = azurerm_windows_virtual_machine.this.id
}

output "virtual_machine_id" {
  value = azurerm_windows_virtual_machine.this.virtual_machine_id
}

output "private_ip_address" {
  value = azurerm_windows_virtual_machine.this.private_ip_address
}

output "private_ip_addresses" {
  value = azurerm_windows_virtual_machine.this.private_ip_addresses
}

output "public_ip_address" {
  value = azurerm_windows_virtual_machine.this.public_ip_address
}

output "public_ip_addresses" {
  value = azurerm_windows_virtual_machine.this.public_ip_addresses
}

output "identity" {
  value = azurerm_windows_virtual_machine.this.identity
}


output "os_managed_disk_id" {
  value = "/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Compute/disks/${var.os_disk.name == null ? "${var.name}-osdisk" : var.os_disk.name}"
}

output "os" {
  value = "windows"
}










