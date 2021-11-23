output "id" {
  value = azurerm_virtual_network.this.id
}

// Making name consistent with output of resource type  "azurerm_subnet'
output "virtual_network_name" {
  value = azurerm_virtual_network.this.name
}

output "virtual_network_guid" {
  value = azurerm_virtual_network.this.guid
}

// Make this a map of object 
output "subnet" {
  value = { for x in azurerm_virtual_network.this.subnet : x.name => {
    "id"             = x.id
    "address_prefix" = local.subnet[x.name].address_prefix
    }
  }
}