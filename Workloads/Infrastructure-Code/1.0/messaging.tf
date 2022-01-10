variable "EventHubs" {
  default = {}
}


module "Landscape-EventHubs" {
  source              = "../../../AzureRM/Modules/Messaging/Azure-EventHub/1.0"
  for_each            = var.EventHubs
  name                = each.value.name == null ? each.key : each.value.name
  namespace_name      = each.value.namespace_name
  resource_group      = each.value.resource_group
  partition_count     = each.value.partition_count
  message_retention   = each.value.message_retention
  capture_description = try(each.value.capture_description, {})
  status              = try(each.value.status, null)
  storage_accounts    = module.Landscape-Storage-Accounts
  resource_groups     = module.Landscape-Resource-Groups
}


output "Landscape-EventHubs" {
  value = module.Landscape-EventHubs
}

variable "EventHubClusters" {
  default = {}
}

module "Landscape-EventHub-Clusters" {
  source          = "../../../AzureRM/Modules/Messaging/Azure-EventHubCluster/1.0"
  for_each        = var.EventHubClusters
  name            = each.value.name == null ? each.key : each.value.name
  resource_group  = each.value.resource_group
  location        = try(each.value.location, null)
  sku_name        = try(each.value.sku_name, "Dedicated_1")
  tags            = try(each.value.tags, local.tags)
  inherit_tags    = try(each.value.inherit_tags, false)
  resource_groups = module.Landscape-Resource-Groups
}

output "EventHubClusters" {
  value = module.Landscape-EventHub-Clusters
}


variable "EventHubNameSpaces" {
  default = {}
}

module "Landscape-EventHub-Namespace" {
  source                   = "../../../AzureRM/Modules/Messaging/Azure-EventHubNamespace/1.0"
  for_each                 = var.EventHubNameSpaces
  name                     = each.value.name == null ? each.key : each.value.name
  resource_group           = each.value.resource_group
  location                 = try(each.value.location, null)
  tags                     = try(each.value.tags, local.tags)
  inherit_tags             = try(each.value.inherit_tags, false)
  sku                      = try(each.value.sku, null)
  capacity                 = try(each.value.capacity, null)
  auto_inflate_enabled     = try(each.value.auto_inflate_enabled, null)
  dedicated_cluster        = try(each.value.dedicated_cluster, null)
  identity                 = try(each.value.identity, null)
  maximum_throughput_units = try(each.value.maximum_throughput_units, null)
  zone_redundant           = try(each.value.zone_redundant, null)
  network_rulesets         = try(each.value.network_rulesets, null)
  virtual_networks         = module.Landscape-Virtual-Networks
  dedicated_clusters       = module.Landscape-EventHub-Clusters
  resource_groups          = module.Landscape-Resource-Groups
}

output "EventHubNamespaces" {
  value = module.Landscape-EventHub-Namespace
}