resource "azurerm_orchestrated_virtual_machine_scale_set" "this" {
  name                        = var.name
  resource_group_name         = local.resource_group_name
  location                    = local.location
  platform_fault_domain_count = var.platform_fault_domain_count
  sku_name                    = var.sku_name
  instances                   = var.instances

  # Multiple blocks, Mandatory
  dynamic "network_interface" {

  }

  # Single Block, Mandatory
  dynamic "os_profile" {
    for_each = local.os_profile == null ? [] : [1]
    content {
      custom_data = local.os_profile.custom_data  # Base 64 encoded custom data

      # Single Block, Optional
      dynamic "windows_configuration"{
        for_each = local.os_profile.windows_configuration == null ? [] : [1]
        content {
          admin_username = local.os_profile.windows_configuration.admin_username
          admin_password = local.os_profile.windows_configuration.admin_password
          computer_name_prefix = local.os_profile.windows_configuration.computer_name_prefix
          enable_automatic_updates = local.os_profile.windows_configuration.enable_automatic_updates
          hotpatching_enabled = local.os_profile.windows_configuration.hotpatching_enabled
          #Hotpatching can only be enabled if the patch_mode is set to AutomaticByPlatform, 
          #the provision_vm_agent is set to true, your source_image_reference references a hotpatching enabled image, 
          #the VM's sku_name is set to a Azure generation 2 VM SKU and the extension contains an application health extension. 
          #An example of how to correctly configure a Orchestrated Virtual Machine Scale Set to provision a Windows Virtual Machine 
          #with hotpatching enabled can be found in the ./examples/orchestrated-vm-scale-set/hotpatching-enabled directory within 
          #the GitHub Repository.
          patch_mode = local.os_profile.windows_configuration.patch_mode
          provision_vm_agent = local.os_profile.windows_configuration.provision_vm_agent
          # Multiple blocks, Optional
          dynamic "secret"{
            
          }
        }
      }
      # Single Block, Optional
      dynamic "linux_configuration"{

      }
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
  source_image_id = local.source_image_id

  # Single Block
  dynamic "source_image_reference" {

  }

  # Single Block
  dynamic "termination_notification" {

  }

  proximity_placement_group_id = local.proximity_placement_group_id
  zones                        = var.zones
  tags                         = local.tags
}