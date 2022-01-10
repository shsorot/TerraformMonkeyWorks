output "id" {
  value = azurerm_network_interface.this.id
}

output "applied_dns_servers" {
  value = azurerm_network_interface.this.applied_dns_servers
}

output "internal_domain_name_suffix" {
  value = azurerm_network_interface.this.internal_domain_name_suffix
}

output "mac_address" {
  value = azurerm_network_interface.this.mac_address
}

output "private_ip_address" {
  value = azurerm_network_interface.this.private_ip_address
}

output "private_ip_addresses" {
  value = azurerm_network_interface.this.private_ip_addresses
}

output "virtual_machine_id" {
  value = azurerm_network_interface.this.virtual_machine_id
}

output "application_security_group_id" {
  value = var.application_security_group == null ? null : (
    var.application_security_group.id == null ? (
      var.application_security_group.name == null ? (
        var.application_security_groups[var.application_security_group.tag].id
      ) : "/subscriptions/${local.subscription_id}/resourceGroups/${try(var.application_security_group.resource_group_name, local.resource_group_name)}/providers/Microsoft.Network/applicationSecurityGroups/${var.application_security_group.name}"
    ) : var.application_security_group.id
  )
}

output "application_security_group_association_id" {
  value = try(var.application_security_group, null) == null ? null : azurerm_network_interface_application_security_group_association.this[0].id
}


output "network_security_group_id" {
  value = var.network_security_group == null ? null : (
    var.network_security_group.id == null ? (
      var.network_security_group.name == null ? (
        var.network_security_groups[var.network_security_group.tag].id
      ) : "/subscriptions/${local.subscription_id}/resourceGroups/${try(var.network_security_group.resource_group_name, local.resource_group_name)}/providers/Microsoft.Network/applicationSecurityGroups/${var.network_security_group.name}"
    ) : var.network_security_group.id
  )
}

output "network_security_group_association_id" {
  value = try(var.network_security_group, null) == null ? null : azurerm_network_interface_security_group_association.this[0].id
}



output "backend_address_pool_association_id" {
  value = [for k, v in azurerm_network_interface_backend_address_pool_association.this : {
    "network_interface_id"  = v.network_interface_id
    "ip_configuration_name" = v.ip_configuration_name
    "backend_address_pool_id" = v.backend_address_pool_id }
  ]
}

