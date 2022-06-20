resource "azurerm_netapp_snapshot_policy" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  account_name        = local.account_name
  enabled             = var.enabled

  # single block
  dynamic "hourly_schedule" {
    for_each = var.hourly_schedule == null || var.hourly_schedule == {} ? [] : [1]
    content {
      snapshots_to_keep = coalesce(var.hourly_schedule.snapshots_to_keep, null)
      minute            = try(var.hourly_schedule.minute, null)
    }
  }
  # single block
  dynamic "daily_schedule" {
    for_each = var.daily_schedule == null || var.daily_schedule == {} ? [] : [1]
    content {
      snapshots_to_keep = coalesce(var.daily_schedule.snapshots_to_keep, null)
      hour              = coalesce(var.daily_schedule.hour, null)
      minute            = coalesce(var.daily_schedule.minute, null)
    }
  }
  # # single block
  dynamic "weekly_schedule" {
    for_each = var.weekly_schedule == null || var.weekly_schedule == {} ? [] : [1]
    content {
      snapshots_to_keep = coalesce(var.weekly_schedule.snapshots_to_keep, null)
      days_of_week      = coalesce(var.weekly_schedule.days_of_week, [])
      hour              = coalesce(var.weekly_schedule.hour, null)
      minute            = coalesce(var.weekly_schedule.minute, null)
    }
  }
  # # single block
  dynamic "monthly_schedule" {
    for_each = var.monthly_schedule == null || var.monthly_schedule == {} ? [] : [1]
    content {
      snapshots_to_keep = coalesce(var.monthly_schedule.snapshots_to_keep, null)
      days_of_month     = coalesce(var.monthly_schedule.days_of_month, null)
      hour              = coalesce(var.monthly_schedule.hour, null)
      minute            = coalesce(var.monthly_schedule.minute, null)
    }
  }

}