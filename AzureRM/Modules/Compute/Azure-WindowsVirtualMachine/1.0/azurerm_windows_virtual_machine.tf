resource "azurerm_windows_virtual_machine" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags
  zone                = var.zone

  admin_username = var.admin_username
  admin_password = var.admin_password

  # Sourced externally currently.
  network_interface_ids = local.network_interface_ids

  # Single Block, Mandatory
  os_disk {
    caching              = var.os_disk.caching == null ? "ReadWrite" : var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type == null ? "Standard_LRS" : var.os_disk.storage_account_type
    dynamic "diff_disk_settings" {
      for_each = var.os_disk.diff_disk_settings == null ? [] : [1]
      content {
        option = var.os_disk.diff_disk_settings.option
      }
    }
    name                      = var.os_disk.name == null ? "${var.name}-osdisk" : var.os_disk.name
    disk_size_gb              = var.os_disk.disk_size_gb == null ? null : var.os_disk.disk_size_gb
    write_accelerator_enabled = var.os_disk.storage_account_type != "Premium_LRS" && var.os_disk.caching != "None" ? false : (var.os_disk.write_accelerator_enabled == null ? false : var.os_disk.write_accelerator_enabled)
    disk_encryption_set_id    = local.disk_encryption_set_id
  }

  size = var.size == null ? "Standard_F2" : var.size

  # Single Block, Optional
  dynamic "additional_capabilities" {
    for_each = var.additional_capabilities == null || var.additional_capabilities == {} ? [] : [1]
    content {
      ultra_ssd_enabled = var.additional_capabilities.ultra_ssd_enabled
    }
  }

  # Multiple Blocks, Optional
  dynamic "additional_unattend_content"{
    for_each = { for idx,instance in var.additional_unattend_content :idx => instance }
    content {
      content = each.value.content
      setting = each.value.content
    }
  }

  # Very important, if set to false, cannot be re-enabled later without recreating VM. This will also block Azure extensions to run.
  allow_extension_operations = var.allow_extension_operations
  availability_set_id        = local.availability_set_id

  # Requires storage account to be in the same region. Currently no checks are done in code and requires due dilligence from dev.
  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics == null ? [] : [1]
    content {
      storage_account_uri = var.boot_diagnostics.storage_account_uri == null ? (
        "https://${var.boot_diagnostics.storage_account_name}.blob.core.windows.net"
      ) : var.boot_diagnostics.storage_account_uri
    }
  }

  # If null, use VM name.
  computer_name = var.computer_name == null ? var.name : var.computer_name
  # changing this forced recreation of VM.
  custom_data = local.custom_data

  # Use either decicated host or dedicated host group. Not both
  dedicated_host_id               = local.dedicated_host_id
  dedicated_host_group_id         = local.dedicated_host_group_id

  # added in provider > 3.xx.x
  edge_zone                  = var.edge_zone
  enable_automatic_updates   = var.enable_automatic_updates
  # Encrypts all disks, including tempt disk.
  encryption_at_host_enabled = var.encryption_at_host_enabled
  # This can only be configured when priority is set to Spot.
  eviction_policy        = var.priority == "Spot" ? var.eviction_policy : null
  extensions_time_budget = var.extensions_time_budget

  # Single Block, Optional
  dynamic "identity" {
    for_each = local.identity == null ? [] : [1]
    content {
      type         = local.identity.type
      identity_ids = local.identity.type == "UserAssigned" ? local.identity.identity_ids : null
    }
  }

  # added in provider > 3.xx.x  
  # Can be None, Windows_Client and Windows_Server. This refers to Azure Hybrid Use Benefit
  license_type  = var.license_type
  # This can only be configured when priority is set to Spot.
  max_bid_price = var.priority == "Spot" ? var.max_bid_price : null

  # Possible values are Manual,AutomaticByOS and AutomaticByPlatform.
  # If patch_mode is set to AutomaticByPlatform then provision_vm_agent must also be set to true. 
  # If the Virtual Machine is using a hotpatching enabled image the patch_mode must always be set to AutomaticByPlatform.
  patch_mode    = var.patch_mode

  dynamic "plan" {
    for_each = var.plan == null ? [] : [1]
    content {
      name      = var.plan.name
      product   = var.plan.product
      publisher = var.plan.publisher
    }
  }

  platform_fault_domain = var.platform_fault_domain
  priority              = var.priority
  # If patch_mode is set to AutomaticByPlatform then provision_vm_agent must also be set to true.
  provision_vm_agent = var.patch_mode == "AutomaticByPlatform " ? true : var.provision_vm_agent

  proximity_placement_group_id = local.proximity_placement_group_id

  # Multiple blocks, Optional
  dynamic "secret" {
    for_each = local.secret
    content {
      key_vault_id = secret.value.key_vault_id
      # multiple blocks, Mandatory
      dynamic "certificate" {
        for_each = secret.value.certificate
        content {
          store = certificate.value.store
          url = certificate.value.url
        }
      }
    }
  }

  # Added in provider > 3.xx.x
  secure_boot_enabled = var.secure_boot_enabled

  # TODO : Add code for lookup of source image using "azurerm_image" and/or "azurerm_images" resource type
  source_image_id = local.source_image_id

  dynamic "source_image_reference" {
    for_each = local.source_image_reference == null ? [1] : []
    content {
      publisher = local.source_image_reference.publisher
      offer     = local.source_image_reference.offer
      sku       = local.source_image_reference.sku
      version   = local.source_image_reference.version
    }
  }

  # Added in provider > 3.xx.x
  # Single block, Optional
  dynamic "termination_notification" {
    for_each = var.termination_notification == null || var.termination_notification == {} ? [] : [1]
    content {
      enabled = var.termination_notification.enabled
      timeout = var.termination_notification.timeout
    }
  }

  # Only supports value from https://jackstromberg.com/2017/01/list-of-time-zones-consumed-by-azure/
  timezone = var.timezone

  # Added in provider > 3.xx.x
  user_data = local.user_data

  # Note that this is "azurerm_orchestrated_virtual_machine_scale_set"
  virtual_machine_scale_set_id = local.virtual_machine_scale_set_id

  # Added in provider > 3.xx.x
  vtpm_enabled = var.vtpm_enabled

  # Multiple Blocks, Optional
  dynamic "winrm_listener"{
    for_each = { for idx,instance in local.winrm_listener : idx => instance}
    content {
      protocol  = each.value.protocol
      certificate_url = each.value.certificate_url
    }
  }

  # Added to ensure that changes in credentials do not cause an accidental re-deployment of VM.
  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      admin_username,
      admin_password,
      custom_data
    ]
  }
}
