resource "azurerm_windows_virtual_machine" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags
  zone                = var.zone

  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = local.network_interface_ids


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

  dynamic "additional_capabilities" {
    for_each = var.additional_capabilities == null ? [] : [1]
    content {
      ultra_ssd_enabled = var.additional_capabilities.ultra_ssd_enabled
    }

  }

  dynamic "additional_unattend_content" {
    for_each = var.additional_unattend_content != null ? [1] : []
    content {
      content = var.additional_unattend_content.content
      setting = var.additional_unattend_content.setting
    }

  }

  allow_extension_operations = var.allow_extension_operations
  availability_set_id        = local.availability_set_id

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics == null ? [] : [1]
    content {
      storage_account_uri = var.boot_diagnostics.storage_account_uri == null ? (
        "https://${var.boot_diagnostics.storage_account_name}.blob.core.windows.net"
      ) : var.boot_diagnostics.storage_account_uri
    }
  }

  computer_name     = var.computer_name == null ? var.name : var.computer_name
  custom_data       = var.custom_data
  dedicated_host_id = local.dedicated_host_id

  enable_automatic_updates   = var.enable_automatic_updates
  encryption_at_host_enabled = var.encryption_at_host_enabled
  eviction_policy            = var.priority == "Spot" ? var.eviction_policy : null
  extensions_time_budget     = var.extensions_time_budget

  dynamic "identity" {
    for_each = local.identity == null ? [] : [1]
    content {
      type         = var.identity.type
      identity_ids = var.identity.type == "UserAssigned" ? var.identity.identity_ids : null
    }
  }
  license_type  = var.license_type
  max_bid_price = var.priority == "Spot" ? var.max_bid_price : null
  patch_mode    = var.patch_mode #This is a preview feature, you can opt-in with the command az feature register -n InGuestAutoPatchVMPreview --namespace Microsoft.Compute


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
  provision_vm_agent    = var.provision_vm_agent

  proximity_placement_group_id = local.proximity_placement_group_id

  dynamic "secret" {
    for_each = local.secret
    content {
      key_vault_id = secret.value.key_vault_id
      dynamic "certificate" {
        for_each = secret.value.certificate
        content {
          url   = certificate.value.url
          store = certificate.value.store
        }
      }
    }
  }

  source_image_id = var.source_image_id

  dynamic "source_image_reference" {
    for_each = var.source_image_id == null ? [1] : []
    content {
      publisher = local.source_image_reference.publisher
      offer     = local.source_image_reference.offer
      sku       = local.source_image_reference.sku
      version   = local.source_image_reference.version
    }
  }
  timezone = var.timezone

  virtual_machine_scale_set_id = local.virtual_machine_scale_set_id

  dynamic "winrm_listener" {
    for_each = var.winrm_listener == null ? [] : var.winrm_listener
    content {
      protocol        = winrm_listener.value.protocol
      certificate_url = winrm_listener.value.certificate_url
    }
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      timezone # Time zone cannot be changed post deployment. Known to cause re-deployment in rare cases.
    ]
  }
}
