

variable "RecoveryServicesVaults" {
  default = {}
}


module "Landscape-Recovery-Service-Vaults" {
  source              = "../../../AzureRM/Modules/RecoveryServices/Azure-RecoveryServicesVault/1.0"
  for_each            = var.RecoveryServicesVaults
  name                = each.value.name == null ? each.key : each.value.name

  resource_group      = each.value.resource_group
  location            = try(each.value.location, null)
  tags                = try(each.value.tags, local.tags)
  inherit_tags        = try(each.value.inherit_tags, false)
  identity_type       = try(each.value.identity_type, "SystemAssigned")
  sku                 = try(each.value.sku, "Standard")
  soft_delete_enabled = try(each.value.soft_delete_enabled, true)
  resource_groups     = module.Landscape-Resource-Groups
}


output "RecoveryServicesVaults" {
  value = module.Landscape-Recovery-Service-Vaults
}

variable "BackupPolicyVMs" {
  default = {}
}

module "Landscape-Backup-Policy-VMs" {
  source                         = "../../../AzureRM/Modules/RecoveryServices/Azure-BackupPolicyVM/1.0"
  for_each                       = var.BackupPolicyVMs
  name                           = each.value.name == null ? each.key : each.value.name

  resource_group                 = each.value.resource_group
  recovery_vault                 = each.value.recovery_vault
  instant_restore_retention_days = try(each.value.instant_restore_retention_days, null)
  timezone                       = try(each.value.timezone, null)
  backup                         = each.value.backup
  retention_daily                = try(each.value.retention_daily, null)
  retention_weekly               = try(each.value.retention_weekly, null)
  retention_monthly              = try(each.value.retention_monthly, null)
  retention_yearly               = try(each.value.retention_yearly, null)
  resource_groups                = module.Landscape-Resource-Groups
  recovery_vaults                = module.Landscape-Recovery-Service-Vaults
}

output "BackupPolicyVMs" {
  value = module.Landscape-Backup-Policy-VMs
}