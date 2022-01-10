output "id" {
  value = azurerm_virtual_network.this.id
}

output "name" {
  value = azurerm_virtual_network.this.name
}

output "subnet" {
  value = { for x in azurerm_subnet.this : x.name => {
    "id"               = x.id               # ID of the subnet.
    "name"             = x.name             # Name of the Subnet
    "address_prefixes" = x.address_prefixes # Address prefix list allocated to this subnet
    # Security group ID if assigned.
    "security_group_id" = local.subnet[x.name].security_group == null ? null : azurerm_subnet_network_security_group_association.this[x.name].id
    # Route table ID if assigned.
    "route_table_id" = local.subnet[x.name].route_table == null ? null : azurerm_subnet_route_table_association.this[x.name].id

    "delegation"        = local.subnet[x.name].delegation        # Any delegation blocks if assigned.
    "service_endpoints" = local.subnet[x.name].service_endpoints # Any service endpoints if assigned.
    }
  }
}