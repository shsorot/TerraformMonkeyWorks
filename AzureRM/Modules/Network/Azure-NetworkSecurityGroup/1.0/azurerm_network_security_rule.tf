resource "azurerm_network_security_rule" "this" {
  for_each                    = local.nsg_rule
  resource_group_name         = local.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name

  name                                  = each.value.name
  description                           = each.value["description"]
  direction                             = each.value["direction"]
  priority                              = each.value["priority"]
  access                                = each.value["access"]
  protocol                              = each.value["protocol"]
  source_address_prefix                 = each.value["source_address_prefix"]
  source_address_prefixes               = each.value["source_address_prefixes"]
  source_application_security_group_ids = each.value.source_application_security_group_ids

  source_port_range            = (each.value["source_port_ranges"] == null) ? (each.value["source_port_range"] == null ? "*" : each.value["source_port_range"]) : null
  source_port_ranges           = each.value["source_port_ranges"]
  destination_address_prefix   = each.value["destination_address_prefix"]
  destination_address_prefixes = each.value["destination_address_prefixes"]

  destination_application_security_group_ids = each.value.destination_application_security_group_ids


  destination_port_range  = (each.value["destination_port_ranges"] == null) ? (each.value["destination_port_range"] == null ? "*" : each.value["destination_port_range"]) : null
  destination_port_ranges = each.value["destination_port_ranges"]
}