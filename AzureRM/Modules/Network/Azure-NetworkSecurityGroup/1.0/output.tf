output "id" {
  value = azurerm_network_security_group.this.id
}

output "nsg_rule" {
  value = local.nsg_rule
}