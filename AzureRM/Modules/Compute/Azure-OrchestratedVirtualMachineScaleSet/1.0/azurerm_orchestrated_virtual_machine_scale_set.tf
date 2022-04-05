resource "azurerm_orchestrated_virtual_machine_scale_set" "this" {
  name                        = var.name
  resource_group_name         = local.resource_group_name
  location                    = local.location
  platform_fault_domain_count = var.platform_fault_domain_count
  sku_name                    = var.sku_name
  instances                   = var.instances

  # Multiple blocks
  dynamic "network_interface" {

  }

  # Single Block
  dynamic "os_profile" {
    for_each = var.os_profile == null ? [] : [1]
    content {
      custom_data = var.os_profile.custom_data

      # Single Block

    }
  }

  # Single Block
  dynamic "os_disk" {

  }

  # Single Block
  dynamic "boot_diagnostics" {

  }

  computer_name_prefix = var.computer_name_prefix

  # Multiple Blocks
  dynamic "data_disk" {

  }

  # Multiple Blocks
  dynamic "extension" {

  }

  extension_time_budget = var.extension_time_budget
  eviction_policy       = local.eviction_policy

  # Single Block
  dynamic "identity" {

  }

  license_type  = var.license_type == null ? "None" : var.license_type
  max_bid_price = var.max_bid_price

  # Single Block
  dynamic "plan" {

  }
  priority        = var.priority == null ? "Regular" : var.priority
  source_image_id = var.source_image_id

  # Single Block
  dynamic "source_image_reference" {

  }

  # Single Block
  dynamic "termination_notification" {

  }

  proximity_placement_group_id = local.proximity_placement_group_id
  single_placement_group       = var.single_placement_group
  zones                        = var.zones
  tags                         = local.tags
}