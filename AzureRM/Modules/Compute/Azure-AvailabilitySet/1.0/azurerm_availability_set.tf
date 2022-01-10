resource "azurerm_availability_set" "this" {
  name                         = var.name
  location                     = local.location
  resource_group_name          = local.resource_group_name
  platform_fault_domain_count  = var.platform_fault_domain_count
  platform_update_domain_count = var.platform_update_domain_count
  proximity_placement_group_id = local.proximity_placement_group_id
  managed                      = var.managed
  tags                         = local.tags
}