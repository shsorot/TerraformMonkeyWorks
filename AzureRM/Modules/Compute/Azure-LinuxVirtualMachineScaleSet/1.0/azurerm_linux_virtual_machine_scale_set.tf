resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags


  admin_username = var.admin_username
  # when admin_password is specified, disable_password_authentication must be set to "false"
  admin_password = var.admin_password

  # If you're using AutoScaling, you may wish to use Terraform's ignore_changes 
  # functionality to ignore changes to this field.
  instances = var.instances
  sku       = var.sku

  # Multiple blocks, Mandatory. This resource does not takes pre-configured NIC instances from azure
  dynamic "network_interface" {
    for_each = { for instance in local.network_interface : instance.name => instance }
    content {
      name = network_interface.value.name
      # Multipel blocks, Mandatory
      # First block is automatically primary
      dynamic "ip_configuration" {
        for_each = { for idx,instance in network_interface.value.ip_configuration :instance.name => merge(instance, {"index":idx})}
        content {
          name = ip_configuration.value.name
          subnet_id = ip_configuration.value.subnet_id
          private_ip_address = ip_configuration.value.private_ip_address
        }
      }
      dns_servers                   = network_interface.value.dns_servers
      enable_accelerated_networking = network_interface.value.enable_accelerated_networking
      network_security_group_id     = network_interface.value.network_security_group_id
      primary                       = network_interface.value.primary
    }
  }

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
  # Currently the only property available is for UltraSSD enable which implements capacity reservation charges
  dynamic "additional_capabilities" {
    for_each = var.additional_capabilities == null || var.additional_capabilities == {} ? [] : [1]
    content {
      ultra_ssd_enabled = var.additional_capabilities.ultra_ssd_enabled
    }
  }
  # It is technically possible to assign SSH key to the admin account while also specifying password. Expect weird behavior at first login.
  # Multiple Blocks, Optional
  dynamic "admin_ssh_key" {
    for_each = var.admin_ssh_key == null || var.admin_ssh_key == [] ? [] : var.admin_ssh_key
    content {
      public_key = admin_ssh_key.value.public_key
      username   = admin_ssh_key.value.username
    }
  }

  # Single block, Optional
  dynamic "automatic_os_upgrade_policy" {

  }

  # Single block, Optional
  dynamic "automatic_instance_repair" {

  }

  # Single block, Optional
  dynamic "boot_diagnostics" {

  }


  computer_name_prefix = var.computer_name_prefix
  #When Custom Data has been configured, it's not possible to remove it without tainting the Virtual Machine Scale Set, due to a limitation of the Azure API
  custom_date = var.custom_data

  # Multiple blocks, Optional
  dynamic "data_disk"{

  }

  # Defaults to false, If True, admin_ssh block MUST be used.
  disable_password_authentication = var.disable_password_authentication

  # When enabled, VM extensions will not be fun on overprovisioned virtual machines
  do_not_run_extensions_on_overprovisioned_machines = var.do_not_run_extensions_on_overprovisioned_machines
  edge_zone = var.edge_zone
  encryption_at_host_enabled = var.encryption_at_host_enabled

  # Single block, Optional
  dynamic "extension"{

  }
  extensions_time_budget = var.extensions_time_budget
  eviction_policy = var.eviction_policy
  health_probe_id = local.health_probe_id

  # Single block, Optional
  dynamic "identity"{

  }

  max_bid_price = var.max_bid_price
  overprovision = var.overprovision

  # Single block, Optional
  dynamic "plan" {
    for_each = var.plan == null ? [] : [1]
    content {
      name      = var.plan.name
      product   = var.plan.product
      publisher = var.plan.publisher
    }
  }

  platform_fault_domain_count = var.platform_fault_domain_count
  priority = var.priority
  # When set to false, default Azure extensions will not be installed on the VM.
  # This is only recommended to be set to false under very specific circumstances (e.g. for a test environment, 3rd party appliances, pre-configured custom images)
  provision_vm_agent = var.provision_vm_agent

  # Single block, Optional
  dynamic "rolling_upgrade_policy" {
    
  }
  scale_in_policy = var.scale_in_policy

  # Multiple block, Optional
  dynamic "secret"{

  }

  secure_boot_enabled =  var.secure_boot_enabled
  single_placement_group = var.single_placement_group
  # Specify a custom image ID.
  # Either source_image_id or source_image_reference must be used.
  source_image_id = local.source_image_id
  # Single block, Optional
  dynamic "source_image_reference" {
    
  }
  
  # Single block, Optional
  dynamic "termination_notification"{

  }

  upgrade_mode = var.upgrade_mode
  # The Base64-Encoded User Data which should be used for this Virtual Machine Scale Set.
  user_data = local.user_data
  vtpm_enabled = var.vtpm_enabled
  zone_balance = var.zone_balance
  zones = var.zones

  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      admin_username,
      admin_password,
      admin_ssh_key,
      custom_data
    ]
  }

}