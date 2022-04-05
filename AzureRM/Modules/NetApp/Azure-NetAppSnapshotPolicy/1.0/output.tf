output "id"{
  value = azurerm_netapp_snapshot_policy.this.id
}

output "name"{
  value = azurerm_netapp_snapshot_policy.this.name
}

output "resource_group_name"{
  value = azurerm_netapp_snapshot_policy.this.resource_group_name
}

output "account_name"{
  value = azurerm_netapp_snapshot_policy.this.account_name
}

output "enabled"{
  value = azurerm_netapp_snapshot_policy.this.enabled
}

output "hourly_schedule"{
  value = azurerm_netapp_snapshot_policy.this.hourly_schedule
}

output "daily_schedule"{
  value = azurerm_netapp_snapshot_policy.this.daily_schedule
}

output "weekly_schedule"{
  value = azurerm_netapp_snapshot_policy.this.weekly_schedule
}

output "monthly_schedule"{
  value = azurerm_netapp_snapshot_policy.this.monthly_schedule
}