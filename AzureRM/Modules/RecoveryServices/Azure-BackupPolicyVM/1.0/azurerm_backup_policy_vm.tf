resource "azurerm_backup_policy_vm" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  recovery_vault_name = local.recovery_vault_name
  # Deprecated in provider > 3.00.0
  # tags                = local.tags

  backup {
    frequency = var.backup.frequency
    time      = var.backup.time
    weekdays  = var.backup.weekdays
  }

  timezone                       = var.timezone
  instant_restore_retention_days = var.instant_restore_retention_days

  dynamic "retention_daily" {
    for_each = var.retention_daily == null ? [] : [1]
    content {
      count = var.retention_daily.count < 7 ? 7 : (
        var.retention_daily.count > 9999 ? 9999 : var.retention_daily.count
      )
    }
  }
  dynamic "retention_weekly" {
    for_each = var.retention_weekly == null ? [] : [1]
    content {
      count = var.retention_weekly.count < 7 ? 7 : (
        var.retention_weekly.count > 9999 ? 9999 : var.retention_weekly.count
      )
      weekdays = var.retention_weekly.weekdays
    }
  }
  dynamic "retention_monthly" {
    for_each = var.retention_monthly == null ? [] : [1]
    content {
      count = var.retention_monthly.count < 7 ? 7 : (
        var.retention_monthly.count > 9999 ? 9999 : var.retention_monthly.count
      )
      weekdays = var.retention_monthly.weekdays
      weeks    = var.retention_monthly.weeks
    }
  }
  dynamic "retention_yearly" {
    for_each = var.retention_yearly == null ? [] : [1]
    content {
      count = var.retention_yearly.count < 7 ? 7 : (
        var.retention_yearly.count > 9999 ? 9999 : var.retention_yearly.count
      )
      weekdays = var.retention_yearly.weekdays
      weeks    = var.retention_yearly.weeks
      months   = var.retention_yearly.months
    }
  }
}