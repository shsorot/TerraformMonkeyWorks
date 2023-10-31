
variable "SSHPublicKeys" {
  default = {}
}

module "Landscape-SSH-Public-Keys" {
  source          = "../../../AzureRM/Modules/Compute/Azure-SSHPublicKey/1.0"
  for_each        = var.SSHPublicKeys
  name            = each.value.name == null ? each.key : each.value.name

  resource_group  = each.value.resource_group
  location        = try(each.value.location, null)
  tags            = try(each.value.tags, local.tags)
  inherit_tags    = try(each.value.inherit_tags, false)
  public_key      = each.value.public_key
  resource_groups = module.Landscape-Resource-Groups
}


output "SSHPublicKeys" {
  value = module.Landscape-SSH-Public-Keys
}


variable "AvailabilitySets" {
  default = {}
}


module "Landscape-Availability-Sets" {
  source                       = "../../../AzureRM/Modules/Compute/Azure-AvailabilitySet/1.0"
  for_each                     = var.AvailabilitySets
  name                         = each.value.name == null ? each.key : each.value.name

  resource_group               = each.value.resource_group
  location                     = try(each.value.location, null)
  platform_fault_domain_count  = try(each.value.platform_fault_domain_count, 2)
  platform_update_domain_count = try(each.value.platform_update_domain_count, 5)
  proximity_placement_group    = try(each.value.proximity_placement_group, null)
  managed                      = try(each.value.managed, null)
  tags                         = try(each.value.tags, local.tags)
  inherit_tags                 = try(each.value.inherit_tags, false)
  proximity_placement_groups   = module.Landscape-ProximityPlacement-Groups
  resource_groups              = module.Landscape-Resource-Groups
}

output "AvailabilitySets" {
  value = module.Landscape-Availability-Sets
}

variable "DiskAccess" {
  default = {}
}

module "Landscape-Disk-Access" {
  source          = "../../../AzureRM/Modules/Compute/Azure-DiskAccess/1.0"
  for_each        = var.DiskAccess
  name            = each.value.name == null ? each.key : each.value.name

  resource_group  = each.value.resource_group
  location        = try(each.value.location, null)
  tags            = try(each.value.tags, local.tags)
  inherit_tags    = try(each.value.inherit_tags, false)
  resource_groups = module.Landscape-Resource-Groups
}


variable "ProximityPlacementGroups" {
  default = {}
}

module "Landscape-ProximityPlacement-Groups" {
  source          = "../../../AzureRM/Modules/Compute/Azure-ProximityPlacementGroup/1.0"
  for_each        = var.ProximityPlacementGroups
  name            = each.value.name == null ? each.key : each.value.name
  resource_group  = each.value.resource_group
  location        = try(each.value.location, null)
  tags            = try(each.value.tags, local.tags)
  inherit_tags    = try(each.value.inherit_tags, false)
  resource_groups = module.Landscape-Resource-Groups
}

output "ProximityPlacementGroups" {
  value = module.Landscape-ProximityPlacement-Groups
}


variable "DedicatedHosts" {
  default = {}
}

module "Landscape-Azure-Dedicated-Hosts" {
  source                  = "../../../AzureRM/Modules/Compute/Azure-DedicatedHost/1.0"
  for_each                = var.DedicatedHosts
  name                    = each.value.name == null ? each.key : each.value.name
  location                = try(each.value.location, null)
  tags                    = try(each.value.tags, local.tags)
  inherit_tags            = try(each.value.inherit_tags, false)
  dedicated_host_group    = try(each.value.dedicated_host_group_id, null)
  platform_fault_domain   = try(each.value.platform_fault_domain, null)
  auto_replace_on_failure = try(each.value.auto_replace_on_failure, false)
  sku_name                = try(each.value.sku_name, null)
  license_type            = try(each.value.license_type, null)
  dedicated_host_groups   = module.Landscape-Azure-Dedicated-Host-Groups
}

output "DedicatedHosts" {
  value = module.Landscape-Azure-Dedicated-Host-Groups
}


variable "DedicatedHostGroups" {
  default = {}
}

module "Landscape-Azure-Dedicated-Host-Groups" {
  source                      = "../../../AzureRM/Modules/Compute/Azure-DedicatedHostGroup/1.0"
  for_each                    = var.DedicatedHostGroups
  name                        = each.value.name == null ? each.key : each.value.name
  resource_group              = each.value.resource_group
  location                    = try(each.value.location, null)
  tags                        = try(each.value.tags, local.tags)
  inherit_tags                = try(each.value.inherit_tags, false)
  zone                        = try(each.value.zone, null)
  platform_fault_domain_count = each.value.platform_fault_domain_count
  automatic_placement_enabled = try(each.value.automatic_placement_enabled, null)
  resource_groups             = module.Landscape-Resource-Groups
}


output "DedicatedHostGroups" {
  value = module.Landscape-Azure-Dedicated-Host-Groups
}



variable "DiskEncryptionSets" {
  default = {}
}

module "Landscape-Disk-Encryption-Sets" {
  source                    = "../../../AzureRM/Modules/Compute/Azure-DiskEncryptionSet/1.0"
  for_each                  = var.DiskEncryptionSets
  name                      = each.value.name == null ? each.key : each.value.name
  resource_group            = each.value.resource_group
  location                  = try(each.value.location, null)
  tags                      = try(each.value.tags, local.tags)
  inherit_tags              = try(each.value.inherit_tags, false)
  key_vault_key             = each.value.key_vault_key
  identity                  = try(each.value.identity, null)
  auto_key_rotation_enabled = try(each.value.auto_key_rotation_enabled, false)
  encryption_type           = try(each.value.encryption_type, "EncryptionAtRestWithCustomerKey")
  resource_groups           = module.Landscape-Resource-Groups
}

output "DiskEncryptionSets" {
  value = module.Landscape-Disk-Encryption-Sets
}



variable "ManagedDisks" {
  default = {}
}

module "Landscape-Managed-Disks" {
  source                        = "../../../AzureRM/Modules/Compute/Azure-ManagedDisk/1.0"
  for_each                      = var.ManagedDisks
  name                          = each.value.name == null ? each.key : each.value.name
  resource_group                = each.value.resource_group
  location                      = try(each.value.location, null)
  tags                          = try(each.value.tags, local.tags)
  inherit_tags                  = try(each.value.inherit_tags, false)
  zone                          = try(each.value.zone, null)
  storage_account_type          = try(each.value.storage_account_type, "Standard_LRS")
  create_option                 = try(each.value.create_option, "Empty")
  disk_encryption_set           = try(each.value.disk_encryption_set_id, null)
  disk_iops_read_write          = try(each.value.disk_iops_read_write, null)
  disk_mbps_read_write          = try(each.value.disk_mbps_read_write, null)
  disk_iops_read_only           = try(each.value.disk_iops_read_only, null)
  disk_mbps_read_only           = try(each.value.disk_mbps_read_only, null)
  disk_size_gb                  = try(each.value.disk_size_gb, 32)
  edge_zone                     = try(each.value.edge_zone, null)
  encryption_settings           = try(each.value.encryption_settings, null)
  hyper_v_generation            = try(each.value.hyper_v_generation, null)
  image_reference_id            = try(each.value.image_reference_id, null)
  gallery_image_reference_id    = try(each.value.gallery_image_reference_id, null)
  logical_sector_size           = try(each.value.logical_sector_size, 4096)
  max_shares                    = try(each.value.max_shares, null)
  public_network_access_enabled = try(each.value.public_network_access_enabled, true)
  os_type                       = try(each.value.os_type, null)
  on_demand_bursting_enabled    = try(each.value.on_demand_bursting_enabled, false)
  source_resource_id            = try(each.value.source_resource_id, null)
  source_uri                    = try(each.value.source_uri, null)
  storage_account_id            = try(each.value.storage_account_id, null)
  tier                          = try(each.value.tier, null)
  trusted_launch_enabled        = try(each.value.trusted_launch_enabled, false)
  network_access_policy         = try(each.value.network_access_policy, "AllowAll")
  disk_access_id                = try(each.value.disk_access_id, null)
  resource_groups               = module.Landscape-Resource-Groups
}


output "ManagedDisks" {
  value = module.Landscape-Managed-Disks
}

variable "ManagedDiskSASTokens"{
  default = {}
}

module "Landscape-Disk-SASToken" {
  source = "../../../AzureRM/Modules/Compute/Azure-DiskSASToken/1.0"
  for_each = var.ManagedDiskSASTokens
  managed_disk = each.value.managed_disk
  duration_in_seconds = each.value.duration_in_seconds
  access_level = each.value.access_level
  managed_disks = module.Landscape-Managed-Disks
}

output "ManagedDiskSASTokens"{
  value = module.Landscape-Disk-SASToken
}

variable "LinuxVirtualMachines" {
  default = {}
}

#TODO Add PPG support.
module "Landscape-Azure-Linux-Virtual-Machines" {
  source                          = "../../../AzureRM/Modules/Compute/Azure-LinuxVirtualMachine/1.0"
  for_each                        = var.LinuxVirtualMachines
  name                            = each.value.name == null ? each.key : each.value.name
  resource_group                  = try(each.value.resource_group, null)
  location                        = try(try(each.value.location, null), null)
  tags                            = try(each.value.tags, local.tags)
  inherit_tags                    = try(each.value.inherit_tags, false)
  zone                            = try(each.value.zone, null)
  admin_username                  = try(each.value.admin_username, "azureadmin")
  admin_password                  = try(each.value.admin_password, null)
  admin_ssh_key                   = try(each.value.admin_ssh_key, null)
  disable_password_authentication = try(each.value.disable_password_authentication, false)
  network_interface               = each.value.network_interface
  os_disk                         = try(each.value.os_disk, {})
  size                            = try(each.value.size, "Standard_F2")
  additional_capabilities         = try(each.value.additional_capabilities, null)
  allow_extension_operations      = try(each.value.allow_Extension_operations, null)
  availability_set                = try(each.value.availability_set, null)
  boot_diagnostics                = try(each.value.boot_diagnostics, null)
  computer_name                   = try(each.value.computer_name, null)
  custom_data                     = try(each.value.custom_data, null)
  dedicated_host                  = try(each.value.dedicated_host, null)
  dedicated_host_group            = try(each.value.dedicated_host_group, null)
  edge_zone                       = try(each.value.edge_zone, null)
  encryption_at_host_enabled      = try(each.value.encryption_at_host_enabled, false)
  eviction_policy                 = try(each.value.eviction_policy, null)
  extensions_time_budget          = try(each.value.extensions_time_budget, "PT1H30M")
  identity                        = try(each.value.identity, null)
  license_type                    = try(each.value.license_type, null)
  max_bid_price                   = try(each.value.max_bid_price, null)
  patch_mode                      = try(each.value.patch_mode, "ImageDefault")
  plan                            = try(each.value.plan, null)
  platform_fault_domain           = try(each.value.platform_fault_domain, null)
  priority                        = try(each.value.priority, "Regular")
  provision_vm_agent              = try(each.value.provision_vm_agent, true)
  proximity_placement_group       = try(each.value.proximity_placement_group, null)
  secret                          = try(each.value.secret, null)
  secure_boot_enabled             = try(each.value.secure_boot_enabled, false)
  source_image                    = try(each.value.source_image, null)
  source_image_reference          = try(each.value.source_image_reference, null)
  termination_notification        = try(each.value.termination_notification, null)
  user_data                       = try(each.value.user_data, null)
  virtual_machine_scale_set       = try(each.value.virtual_machine_scale_set_id, null)
  vtpm_enabled                    = try(each.value.vtpm_enabled, false)

  #Outputs from modules for lookup
  azure_images               = module.Landscape-Azure-Images
  dedicated_hosts            = module.Landscape-Azure-Dedicated-Hosts
  dedicated_host_groups      = module.Landscape-Azure-Dedicated-Host-Groups
  virtual_machine_scale_sets = {}
  disk_encryption_sets       = module.Landscape-Disk-Encryption-Sets
  network_interfaces         = module.Landscape-Virtual-Network-Interfaces
  key_vaults                 = module.Landscape-Key-Vaults
  availability_sets          = module.Landscape-Availability-Sets
  proximity_placement_groups = module.Landscape-ProximityPlacement-Groups
  resource_groups            = module.Landscape-Resource-Groups
  user_assigned_identities   = module.Landscape-User-Assigned-Identities
}

output "LinuxVirtualMachines" {
  value = module.Landscape-Azure-Linux-Virtual-Machines
}



variable "WindowsVirtualMachines" {
  default = {}
}

#TODO Add PPG support.
module "Landscape-Azure-Windows-Virtual-Machines" {
  source                      = "../../../AzureRM/Modules/Compute/Azure-WindowsVirtualMachine/1.0"
  for_each                    = var.WindowsVirtualMachines
  name                        = each.value.name == null ? each.key : each.value.name

  resource_group              = try(each.value.resource_group, null)
  location                    = try(try(each.value.location, null), null)
  tags                        = try(each.value.tags, local.tags)
  zone                        = try(each.value.zone, null)
  admin_username              = try(each.value.admin_username, "azureadmin")
  admin_password              = try(each.value.admin_password, null)
  network_interface           = each.value.network_interface
  os_disk                     = try(each.value.os_disk, {})
  size                        = try(each.value.size, "Standard_F2")
  additional_capabilities     = try(each.value.additional_capabilities, null)
  additional_unattend_content = try(each.value.additional_unattend_content, null)
  allow_extension_operations  = try(each.value.allow_Extension_operations, null)
  availability_set            = try(each.value.availability_set, null)
  boot_diagnostics            = try(each.value.boot_diagnostics, null)
  computer_name               = try(each.value.computer_name, null)
  custom_data                 = try(each.value.custom_data, null)
  dedicated_host              = try(each.value.dedicated_host_id, null)
  enable_automatic_updates    = try(each.value.enable_automatic_updates, false)
  encryption_at_host_enabled  = try(each.value.encryption_at_host_enabled, false)
  eviction_policy             = try(each.value.eviction_policy, null)
  extensions_time_budget      = try(each.value.extensions_time_budget, "PT1H30M")
  identity                    = try(each.value.identity, null)
  license_type                = try(each.value.license_type, null)
  max_bid_price               = try(each.value.max_bid_price, null)
  patch_mode                  = try(each.value.patch_mode, "Manual")
  plan                        = try(each.value.plan, null)
  platform_fault_domain       = try(each.value.platform_fault_domain, null)
  priority                    = try(each.value.priority, "Regular")
  provision_vm_agent          = try(each.value.provision_vm_agent, true)
  proximity_placement_group   = try(each.value.proximity_placement_group, null)
  secret                      = try(each.value.secret, null)
  source_image                = try(each.value.source_image, null)
  source_image_reference      = try(each.value.source_image_reference, null)
  timezone                    = try(each.value.timezone, null)
  virtual_machine_scale_set   = try(each.value.virtual_machine_scale_set_id, null)
  winrm_listener              = try(each.value.winrm_listener, null)
  #Outputs from modules for lookup
  dedicated_hosts                                 = module.Landscape-Azure-Dedicated-Hosts
  virtual_machine_scale_sets                      = {}
  disk_encryption_sets                            = module.Landscape-Disk-Encryption-Sets
  network_interfaces                              = module.Landscape-Virtual-Network-Interfaces
  key_vaults                                      = module.Landscape-Key-Vaults
  availability_sets                               = module.Landscape-Availability-Sets
  proximity_placement_groups                      = module.Landscape-ProximityPlacement-Groups
  resource_groups                                 = module.Landscape-Resource-Groups
  user_assigned_identities                        = module.Landscape-User-Assigned-Identities
  
}

output "WindowsVirtualMachines" {
  value = module.Landscape-Azure-Windows-Virtual-Machines
}



variable "VirtualMachineManagedDiskAttachments" {
  default = {}
}

module "Landscape-Azure-Virtual-Machine-Managed-Disk-Attachments" {
  source                    = "../../../AzureRM/Modules/Compute/Azure-VirtualMachineDataDiskAttachment/1.0"
  for_each                  = var.VirtualMachineManagedDiskAttachments

  virtual_machine           = each.value.virtual_machine
  managed_disk              = each.value.managed_disk
  lun                       = each.value.lun
  caching                   = try(each.value.caching, "None")
  create_option             = try(each.value.create_option, "Attach")
  write_accelerator_enabled = try(each.value.write_accelerator_enabled, false)
  #  virtual_machines            = merge(module.Landscape-Azure-Windows-Virtual-Machines, module.Landscape-Azure-Linux-Virtual-Machines, module.Landscape-Azure-Virtual-Machines)
  virtual_machines = merge(module.Landscape-Azure-Windows-Virtual-Machines, module.Landscape-Azure-Linux-Virtual-Machines)
  managed_disks    = module.Landscape-Managed-Disks
}

output "VirtualMachineManagedDiskAttachments" {
  value = module.Landscape-Azure-Virtual-Machine-Managed-Disk-Attachments
}









variable "VirtualMachineExtensions" {
  default = {}
}

module "Landscape-Virtual-Machine-Extensions" {
  source                     = "../../../AzureRM/Modules/Compute/Azure-VirtualMachineExtension/1.0"
  for_each                   = var.VirtualMachineExtensions

  name                       = each.value.name == null ? each.key : each.value.name
  tags                       = try(each.value.tags, local.tags)
  virtual_machine            = try(each.value.virtual_machine, null)
  publisher                  = each.value.publisher
  type                       = each.value.type
  type_handler_version       = each.value.type_handler_version
  auto_upgrade_minor_version = try(each.value.auto_upgrade_minor_version, true)
  settings                   = each.value.settings
  protected_settings         = each.value.protected_settings
  virtual_machines           = merge(module.Landscape-Azure-Windows-Virtual-Machines, module.Landscape-Azure-Linux-Virtual-Machines)
}

output "VirtualMachineExtensions" {
  value = module.Landscape-Virtual-Machine-Extensions
}


variable "ADDS-DomainJoin" {
  default = {}
}

module "Landscape-ADDS-DomainJoin" {
  source                    = "../../../AzureRM/Modules/Compute/Azure-VirtualMachineDomainJoin/1.0"
  for_each                  = var.VirtualMachineExtensions
  
  tags                      = try(each.value.tags, local.tags)
  virtual_machine           = try(each.value.virtual_machine, null)
  active_directory_domain   = each.value.active_directory_domain
  ou_path                   = each.value.ou_path
  active_directory_username = each.value.active_directory_username
  active_directory_password = each.value.active_directory_password
  virtual_machines          = merge(module.Landscape-Azure-Windows-Virtual-Machines, module.Landscape-Azure-Linux-Virtual-Machines)
}

output "ADDS-DomainJoin" {
  value = module.Landscape-ADDS-DomainJoin
}

# TODO : add code for Azure-Image once VM functions are completed.
variable "AzureImages"{
  default = {}
}

module "Landscape-Azure-Images"{
  source                         = "../../../AzureRM/Modules/Compute/Azure-Image/1.0"
  for_each                       = var.AzureImages
  name                           = each.value.name == null ? each.key : each.value.name
  resource_group                 = each.value.resource_group
  location                       = each.value.location
  tags                           = try(each.value.tags,null)
  inherit_tags                   = try(each.value.inherit_tags, false)
  source_virtual_machine         = try(each.value.source_virtual_machine.null)
  os_disk                        = try(each.value.os_disk,null)
  data_disk                      = try(each.value.data_disk,[])
  zone_resilient                 = try(each.value.zone_resilient,false)
  hyper_v_generation             = try(each.value.hyper_v_generation,"V1")
  #Outputs from modules for lookup
  resource_groups                = module.Landscape-Resource-Groups
}

output "AzureImages"{
  value = module.Landscape-Azure-Images
}