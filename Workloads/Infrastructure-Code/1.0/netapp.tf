variable "NetAppAccounts" {
  default = {}
}

module "Landscape-NetApp-Accounts" {
  source           = "../../../AzureRM/Modules/NetApp/Azure-NetAppAccount/1.0"
  for_each         = var.NetAppAccounts
  name             = each.value.name == null ? each.key : each.value.name
  resource_group   = each.value.resource_group
  location         = try(each.value.location, null)
  tags             = try(each.value.tags, local.tags)
  inherit_tags     = try(each.value.inherit_tags, false)
  active_directory = try(each.value.active_directory, null)
  resource_groups  = module.Landscape-Resource-Groups
}

output "NetAppAccounts" {
  value = module.Landscape-NetApp-Accounts
}

variable "NetAppSnapshotPolicies" {
  default = {}
}

module "Landscape-NetApp-Snapshot-Policies" {
  source           = "../../../AzureRM/Modules/NetApp/Azure-NetAppSnapshotPolicy/1.0"
  for_each         = var.NetAppSnapshotPolicies
  name             = each.value.name == null ? each.key : each.value.name
  resource_group   = each.value.resource_group
  location         = try(each.value.location, null)
  account          = each.value.account
  tags             = try(each.value.tags, local.tags)
  inherit_tags     = try(each.value.inherit_tags, false)
  enabled          = try(each.value.enabled, false)
  daily_schedule   = try(each.value.daily_schedule, null)
  hourly_schedule  = try(each.value.hourly_schedule, null)
  weekly_schedule  = try(each.value.weekly_schedule, null)
  monthly_schedule = try(each.value.monthly_schedule, null)
  netapp_accounts  = module.Landscape-NetApp-Accounts
  resource_groups  = module.Landscape-Resource-Groups
}

output "NetAppSnapshotPolicies" {
  value = module.Landscape-NetApp-Snapshot-Policies
}

variable "NetAppPools" {
  default = {}
}

module "Landscape-NetApp-Pools" {
  source          = "../../../AzureRM/Modules/NetApp/Azure-NetAppPool/1.0"
  for_each        = var.NetAppPools
  name            = each.value.name == null ? each.key : each.value.name
  resource_group  = each.value.resource_group
  location        = try(each.value.location, null)
  tags            = try(each.value.tags, local.tags)
  inherit_tags    = try(each.value.inherit_tags, false)
  account         = each.value.account
  size_in_tb      = try(each.value.size_in_tb, 4)
  qos_type        = try(each.value.qos_type, "Auto")
  service_level   = try(each.value.service_level, "Standard")
  resource_groups = module.Landscape-Resource-Groups
  netapp_accounts = module.Landscape-NetApp-Accounts
}

output "NetAppPools" {
  value = module.Landscape-NetApp-Pools
}


variable "NetAppVolumes" {
  default = {}
}

# TODO: add snapshot policy and snapshot module output for volume creation
module "Landscape-Netapp-Volumes" {
  source                          = "../../../AzureRM/Modules/NetApp/Azure-NetAppVolume/1.0"
  for_each                        = var.NetAppVolumes
  name                            = each.value.name == null ? each.key : each.value.name
  resource_group                  = each.value.resource_group
  location                        = try(each.value.location, null)
  tags                            = try(each.value.tags, local.tags)
  inherit_tags                    = try(each.value.inherit_tags, false)
  account                         = each.value.account
  pool                            = each.value.pool
  volume_path                     = each.value.volume_path
  protocols                       = try(each.value.protocols, ["NFSv4.1"])
  security_style                  = try(each.value.security_style, "Unix")
  subnet                          = each.value.subnet
  storage_quota_in_gb             = each.value.storage_quota_in_gb
  snapshot_directory_visible      = try(each.value.snapshot_directory_visible, false)
  create_from_snapshot_resource   = try(each.value.create_from_snapshot_resource, null)
  data_protection_replication     = try(each.value.data_protection_replication, null)
  data_protection_snapshot_policy = try(each.value.data_protection_snapshot_policy, null)
  export_policy_rule              = try(each.value.export_policy_rule, null)
  throughput_in_mibps             = try(each.value.throughput_in_mibps, null)
  virtual_networks                = module.Landscape-Virtual-Networks
  resource_groups                 = module.Landscape-Resource-Groups
  netapp_accounts                 = module.Landscape-NetApp-Accounts
  netapp_pools                    = module.Landscape-NetApp-Pools
  snapshot_policies               = module.Landscape-NetApp-Snapshot-Policies
  netapp_snapshots                = {}
}

output "NetAppVolumes" {
  value = module.Landscape-Netapp-Volumes
}