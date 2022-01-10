# This file contains local & data blocks
data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {
}

data "azurerm_resource_group" "this" {
  count = var.resource_group.name == null ? 0 : 1
  name  = var.resource_group.name
}

#Create the local variables
locals {
  client_id               = data.azurerm_client_config.current.client_id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_client_config.current.object_id
  subscription_id         = data.azurerm_subscription.current.subscription_id
  resource_group_name     = var.resource_group.name == null ? var.resource_groups[var.resource_group.tag].name : data.azurerm_resource_group.this[0].name
  resource_group_tags     = var.resource_group.name == null ? var.resource_groups[var.resource_group.tag].tags : data.azurerm_resource_group.this[0].tags
  tags                    = merge(var.tags, (var.inherit_tags == true ? local.resource_group_tags : {}))
  resource_group_location = var.resource_group.name == null ? var.resource_groups[var.resource_group.tag].location : data.azurerm_resource_group.this[0].location
  location                = var.location == null ? local.resource_group_location : var.location
}

data "azurerm_firewall_policy" "this" {
  count               = var.base_policy_id == null ? 0 : (var.base_policy_id.name == null ? 0 : 1)
  name                = var.base_policy_id.name
  resource_group_name = coalesce(var.base_policy_id.resource_group_name, local.resource_group_name)
}

data "azurerm_user_assigned_identity" "this" {
  for_each            = var.identity == null ? {} : { for instance in(var.identity.type == "SystemAssigned" ? [] : var.identity.identity) : instance.name => instance if instance.name != null }
  name                = each.key
  resource_group_name = coalesce(each.value.resource_group_name, local.resource_group_name)
}

data "azurerm_log_analytics_workspace" "default" {
  count = var.insights == null ? 0 : (var.insights.default_local_analytics_workspace.name == null ? 0 : 1)
  name                = var.insights.default_local_analytics_workspace.name
  resource_group_name = coalesce(var.insights.default_local_analytics_workspace.resource_group_name,local.resource_group_name)
}


data "azurerm_key_vault" "this"{
  count = var.tls_certificate == null ? 0 : (var.tls_certificate.key_vault.key_vault_name == null ? 0 : 1)
  name               = var.tls_certificate.key_vault.key_vault_name
  resource_group_name= coalesce(var.tls_certificate.key_vault.resource_group_name, local.resource_group_name)
}

data "azurerm_key_vault_secrets" "this"{
  count = var.tls_certificate == null ? 0 : (var.tls_certificate.key_vault_secret.name == null && var.tls_certificate.key_vault_secret.key_vault_name == null ? 0 : 1)
  name = var.tls_certificate.key_vault_secret.name
  key
}


locals {
  base_policy_id = var.base_policy_id == null ? null : (
    var.base_policy_id.id == null ? (
      var.base_policy_id.name == null ? (
        var.firewall_policies[var.base_policy_id.tag].id
      ) : data.azurerm_firewall_policy.this[0].id
    ) : var.base_policy_id.id
  )

  identity = var.identity == null ? null : (
    {
      type = var.identity.type
      identity_ids = var.identity.type == "UserAssigned" ? (
        [for instance in var.identity.identity : (
          instance.id == null ? (
            instance.name == null ? (
              var.user_assigned_identities[instance.tag].id
            ) : data.azurerm_user_assigned_identity.this[instance.name].id
          ) : instance.id
        )]
      ) : null
    }
  )

  insights = var.insights == null ? null : (
    {
      enabled = var.insights.enabled
      default_local_analytics_workspace_id = var.insights.default_local_analytics_workspace.id == null ? (
        var.insights.default_local_analytics_workspace.name == null ? (
          var.log_analytics_workspaces[var.insights.default_local_analytics_workspace.tag].id
        ) : data.azurerm_log_analytics_workspace.default[0].id
      ) : var.insights.default_local_analytics_workspace.id
    }
  )

  intrusion_detection = var.intrusion_detection == null ? null : (
    {
      mode = var.intrusion_detection.mode
      signature_overrides = { for instance in var.intrusion_detection.signature_overrides : instance.id => instance if instance.id != null }
      traffic_bypass   = { for instnace in var.intrusion_detection.traffic_bypass : instnace.name => instnace if instnace.name != null }
    }
  )
 
}

