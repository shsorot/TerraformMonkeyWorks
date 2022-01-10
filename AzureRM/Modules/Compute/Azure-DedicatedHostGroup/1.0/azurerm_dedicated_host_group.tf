resource "azurerm_dedicated_host_group" "this" {
  name                        = var.name
  resource_group_name         = local.resource_group_name
  location                    = local.location
  tags                        = local.tags
  zones                       = var.zones
  platform_fault_domain_count = var.platform_fault_domain_count
  automatic_placement_enabled = var.automatic_placement_enabled
}
