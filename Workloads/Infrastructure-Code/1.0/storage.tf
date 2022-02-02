variable "StorageAccounts" {
  default = {}
}


module "Landscape-Storage-Accounts" {
  source                     = "../../../AzureRM/Modules/Storage/Azure-StorageAccount/1.0"
  for_each                   = var.StorageAccounts
  name                       = each.value.name == null ? each.key : each.value.name
  resource_group             = each.value.resource_group
  location                   = try(each.value.location, null)
  account_kind               = try(each.value.account_kind, null)
  account_replication_type   = try(each.value.account_replication_type, null)
  access_tier                = try(each.value.access_tier, null)
  enable_https_traffic_only  = try(each.value.enable_https_traffic_only, null)
  min_tls_version            = try(each.value.min_tls_version, null)
  allow_blob_public_access   = try(each.value.allow_blob_public_access, null)
  is_hns_enabled             = try(each.value.is_hns_enabled, null)
  nfsv3_enabled              = try(each.value.nfsv3_enabled, null)
  large_file_share_enabled   = try(each.value.large_file_share_enabled, null)
  blob_properties            = try(each.value.blob_properties, null)
  custom_domain              = try(each.value.custom_domain, null)
  static_website             = try(each.value.static_website, null)
  network_rules              = try(each.value.network_rules, null)
  azure_files_authentication = try(each.value.azures_files_authentication, null)
  routing                    = try(each.value.routing, null)
  tags                       = try(each.value.tags, local.tags)
  inherit_tags               = try(each.value.inherit_tags, false)
  virtual_networks           = module.Landscape-Virtual-Networks
  resource_groups            = module.Landscape-Resource-Groups
}

output "StorageAccounts" {
  value     = module.Landscape-Storage-Accounts
  sensitive = true
}

variable "StorageContainers" {
  default = {}
}

module "Landscape-Storage-Containers" {
  source                = "../../../AzureRM/Modules/Storage/Azure-StorageContainer/1.0"
  for_each              = var.StorageContainers
  name                  = each.value.name == null ? each.key : each.value.name
  storage_account_name  = each.value.storage_account_name
  container_access_type = each.value.container_access_type
  metadata              = each.value.metadata
  depends_on = [
    module.Landscape-Storage-Accounts
  ]
}


output "StorageContainers" {
  value = module.Landscape-Storage-Containers
}

variable "StorageShares" {
  default = {}
}


module "Landscape-Storage-Shares" {
  source               = "../../../AzureRM/Modules/Storage/Azure-StorageShare/1.0"
  for_each             = var.StorageShares
  name                 = each.value.name == null ? each.key : each.value.name
  storage_account_name = each.value.storage_account_name
  acl                  = try(each.value.acl, null)
  quota                = try(each.value.quota, null)
  metadata             = try(each.value.metadata, null)
  depends_on = [
    module.Landscape-Storage-Accounts
  ]
}

output "StorageShares" {
  value = module.Landscape-Storage-Shares
}