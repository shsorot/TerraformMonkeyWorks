resource "azurerm_orchestrated_virtual_machine_scale_set" "this" {
  name                         = var.name
  resource_group_name          = local.resource_group_name
  location                     = local.location
  platform_fault_domain_count  = var.platform_fault_domain_count
  proximity_placement_group_id = local.proximity_placement_group_id
  single_placement_group       = var.single_placement_group
  zones                        = var.zones
  tags                         = local.tags
}