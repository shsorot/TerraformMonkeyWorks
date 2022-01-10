# This resource type in Terraform has exactly one output

output "id" {
  description = "Id of the IP Group. Can be passed to Firewall rule/s collection."
  value       = azurerm_ip_group.this.id
}
