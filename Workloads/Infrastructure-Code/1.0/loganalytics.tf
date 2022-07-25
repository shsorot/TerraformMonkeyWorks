variable "LogAnalyticsWorkspaces" {
  default = {}
}

module "Landscape-Log-Analytics-Workspaces" {
  source                            = "../../../AzureRM/Modules/LogAnalytics/Azure-LogAnalyticsWorkspace/1.0"
  for_each                          = var.LogAnalyticsWorkspaces
  name                              = each.value.name == null ? each.key : each.value.name

  resource_group                    = each.value.resource_group
  location                          = try(each.value.location, null)
  sku                               = try(each.value.sku, "PerGB2018")
  retention_in_days                 = try(each.value.retention_in_days, null)
  daily_quota_gb                    = try(each.value.daily_quota_gb, null)
  internet_ingestion_enabled        = try(each.value.internet_ingestion_enabled, true)
  internet_query_enabled            = try(each.value.internet_ingestion_enabled, true)
  reservation_capcity_in_gb_per_day = try(each.value.reservation_capcity_in_gb_per_day, null)
  tags                              = try(each.value.tags, {})
  inherit_tags                      = try(each.value.inherit_tags, false)
  resource_groups                   = module.Landscape-Resource-Groups
}

output "LogAnalyticsWorkspaces" {
  value     = module.Landscape-Log-Analytics-Workspaces
  sensitive = true
}

variable "LogAnalyticsCluster" {
  default = {}
}


module "Landscape-Log-Analytics-Clusters" {
  source          = "../../../AzureRM/Modules/LogAnalytics/Azure-LogAnalyticsCluster/1.0/"
  for_each        = var.LogAnalyticsCluster
  name            = each.value.name == null ? each.key : each.value.name

  resource_group  = each.value.resource_group
  location        = try(each.value.location, null)
  identity        = try(each.value.identity, { type = "SystemAssigned" })
  size_gb         = try(each.value.size_gb, 1000)
  tags            = try(each.value.tags, {})
  inherit_tags    = try(each.value.inherit_tags, false)
  resource_groups = module.Landscape-Resource-Groups
}


output "LogAnalyticsCluster" {
  value = module.Landscape-Log-Analytics-Clusters
}



variable "LogAnalyticsClusterCustomerManagedKeys" {
  default = {}
}


module "Landscape-Log-Analytics-Cluster-Customer-Managed-Keys" {
  source                 = "../../../AzureRM/Modules/LogAnalytics/Azure-LogAnalyticsClusterCustomerManagedKey/1.0"
  for_each               = var.LogAnalyticsClusterCustomerManagedKeys
  key_vault_key          = each.value.key_vault_key
  log_analytics_cluster  = each.value.log_analytics_cluster
  key_vault_keys         = module.Landscape-Key-Vault-Keys
  log_analytics_clusters = module.Landscape-Log-Analytics-Clusters
}

output "LogAnalyticsClusterCustomerManagedKeys" {
  value = module.Landscape-Log-Analytics-Cluster-Customer-Managed-Keys
}

variable "LogAnalyticsSolutions" {
  default = {}
}

module "Landscape-Log-Analytics-Solutions" {
  source                   = "../../../AzureRM/Modules/LogAnalytics/Azure-LogAnalyticsSolution/1.0"
  for_each                 = var.LogAnalyticsSolutions
  solution_name            = each.value.solution_name
  resource_group           = each.value.resource_group
  location                 = try(each.value.location, null)
  workspace_resource       = each.value.workspace_resource
  workspace_name           = each.value.workspace_name
  plan                     = each.value.plan
  tags                     = try(each.value.tags, {})
  inherit_tags             = try(each.value.inherit_tags, false)
  log_analytics_workspaces = module.Landscape-Log-Analytics-Workspaces
  resource_groups          = module.Landscape-Resource-Groups
}

output "LogAnalyticsSolutions" {
  value = module.Landscape-Log-Analytics-Solutions
}