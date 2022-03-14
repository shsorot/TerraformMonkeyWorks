output "id" {
  value = azurerm_netapp_account.this.id
}

output "name" {
  value = azurerm_netapp_account.this.name
}

output "resource_group_name" {
  value = local.resource_group_name
}

output "location" {
  value = local.location
}