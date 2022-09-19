# Note:
# Terraform will automatically update & reimage the nodes in the Scale Set 
# (if Required) during an Update - this behaviour can be configured using 
# the features setting within the Provider block.
# This resource does not support Unmanaged Disks.
# All arguments including the administrator login and password will be stored in the raw state as plain-text.


resource "azurerm_windows_virtual_machine_scale_set" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags
  # List of zones aplicable for scale set location. Changing recreation
  zones               = var.zones

  admin_username = var.admin_username
  admin_password = var.admin_password

  # if you're using AutoScaling, you may wish to use Terraform's ignore_changes functionality to ignore changes to this field.
  # Since "ignore_changes" cannot be controlled by variables or control statements, this must be set manually
  instances = var.instances

  # Changes from Size in virtual machine to sku in scale set
  sku = var.sku

  # Multiple blocks, Mandatory
  # dynamic "network_interface"{
  #   for_each = local.network_interface
  #   content {
  #     name = network_interface.value.name
  #     # multiple blocks, Mandatory
  #     dynamic "ip_configuration"{
  #       for_each = network_interface.value.ip_configuration
  #       content {
  #         name = ip_configuration.value.name
  #         application_gateway_backend_address_pool_ids = ip_configuration.value.application_gateway_backend_address_pool_ids
  #         application_security_group_ids = ip_configuration.value.application_security_group_ids
  #         load_balancer_backend_address_pool_ids = ip_configuration.value.load_balancer_backend_address_pool_ids
  #         load_balancer_inbound_nat_rules_ids = ip_configuration.value.load_balancer_inbound_nat_rules_ids
  #         primary = ip_configuration.value.primary
  #         # Single block, Optional
  #         dynamic "public_ip_address"{
  #           for_each = ip_configuration.value.ip_configuration == null || ip_configuration.value.ip_configuration == {} ? [] : [1]
  #           content {
  #             name = public_ip_address.value.public_ip_address.name
  #             domain_name_label = public_ip_address.value.public_ip_address.domain_name_label
  #             idle_time
  #           }
  #         subnet_id = ip_configuration.value.subnet_id
  #         version = ip_configuration.value.version

  #         }
  #       }
  #     }
  #     dns_servers = network_interface.value.dns_servers
  #     enable_accelerated_networking = network_interface.vaue.enable_accelerated_networking
  #     enable_ip_forwarding = network_interface.value.enable_ip_forwarding
  #     network_security_group_id = network_interface.value.network_security_group_id
  #     primary = network_interface.value.primar
  #   }
  # }

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

  # Single block, Optional
  dynamic "automatic_os_upgrade_policy"{

  }

  # Single block, Optional
  dynamic "automatic_instance_repair"{

  }


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
  computer_name_prefix = var.computer_name_prefix
  # changing this forced recreation of VM.
  custom_data = local.custom_data

  # Multiple blocks, Optional
  dynamic "data_disk"{

  }

  do_not_run_extensions_on_overprovisioned_machines = var.do_not_run_extensions_on_overprovisioned_machines == null ? false : var.do_not_run_extensions_on_overprovisioned_machines
  
  # added in provider > 3.xx.x
  edge_zone                  = var.edge_zone
  enable_automatic_updates   = var.enable_automatic_updates
  # Encrypts all disks, including tempt disk.
  encryption_at_host_enabled = var.encryption_at_host_enabled
  
  # Multiple block, Optional
  dynamic "extension"{

  }

  extensions_time_budget = var.extensions_time_budget
  # This can only be configured when priority is set to Spot.
  eviction_policy        = var.priority == "Spot" ? var.eviction_policy : null

  # This is Required and can only be specified when upgrade_mode is set to Automatic or Rolling
  health_probe_id = local.health_probe_id

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

  overprovision = var.overprovision


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

  # Single block, Optional
  # Can only be specified when upgrade_mode is set to Automatic or Rolling.
  dynamic "rolling_upgrade_policy"{

  }

  # Possible values for the scale-in policy rules are Default, NewestVM and OldestVM, defaults to Default
  scale_in_policy = var.scale_in_policy

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
  single_placement_group = var.single_placement_group

  # TODO : Add code for lookup of source image using "azurerm_image" and/or "azurerm_images" resource type
  source_image_id = local.source_image_id

  # Either source_image_id or source_image_reference must be used
  # TODO: add a conditional access code
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

  # Possible values are Automatic, Manual and Rolling. Defaults to Manual.
  upgrade_mode = var.upgrade_mode

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

  #  Distributed VM's across zones evenly. Defaults to false
  zone_balance = var.zone_balance

  # Added to ensure that changes in credentials do not cause an accidental re-deployment of VMSS.
  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      admin_username,
      admin_password
    ]
  }
}
