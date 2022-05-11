output "id"{
  value = azurerm_container_group.this.id
}

output "resource_group_name" {
  value = azurerm_container_group.this.resource_group_name
}

output "location"{
  value = local.location
}

output "name" {
  value = var.name
}

output "identity"{
  value = azurerm_container_group.this.identity
}

output "ip_address"{
  value = azurerm_container_group.this.ip_address
}

output "fqdn"{
  value = azurerm_container_group.this.ip_address
}