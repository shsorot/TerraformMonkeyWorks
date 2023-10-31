resource "azurerm_storage_account" "this" {
  tags                = local.tags
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location

  account_kind = (var.account_kind == null) ? "StorageV2" : var.account_kind
  account_tier = (var.account_tier == null) ? "Standard" : var.account_tier

  account_replication_type  = (var.account_replication_type == null) ? "LRS" : var.account_replication_type
  access_tier               = (var.access_tier == null) ? "Hot" : var.access_tier
  enable_https_traffic_only = var.enable_https_traffic_only
  min_tls_version           = (var.min_tls_version == null) ? "TLS1_0" : var.min_tls_version

  #This should be false by default
  # Deprecated in provider > 3.00.0
  # allow_blob_public_access  = (var.allow_blob_public_access == null) ? false : var.allow_blob_public_access
  allow_nested_items_to_be_public = (var.allow_blob_public_access == null) ? false : var.allow_blob_public_access
  shared_access_key_enabled = var.shared_access_key_enabled
  is_hns_enabled            = var.is_hns_enabled

  # Added encryption options post provider version 2.94.0
  # TODO, add option to allow supplying custom certificates/keys for encryption.
  infrastructure_encryption_enabled = var.account_kind == "StorageV2" || var.account_kind == null ? var.infrastructure_encryption_enabled : false
  queue_encryption_key_type         = var.queue_encryption_key_type == null ? "Service" : var.queue_encryption_key_type
  table_encryption_key_type         = var.table_encryption_key_type == null ? "Service" : var.table_encryption_key_type

  #New NFS v3 feature. Requries subscription onboarding
  nfsv3_enabled            = var.nfsv3_enabled
  large_file_share_enabled = var.large_file_share_enabled

  # Single blocks

  dynamic "identity" {
    for_each = var.identity == null || var.identity == {} ? [] : [1]
    content {
      type = var.identity.type == null ? "SystemAssigned" : var.identity.type
    }

  }

  dynamic "blob_properties" {
    for_each = var.blob_properties == null || var.blob_properties == {} ? [] : [1]
    content {
      dynamic "cors_rule" {
        for_each = var.blob_properties.cors_rule == null || var.blob_properties.cors_rule == {} ? [] : [1]
        content {
          allowed_headers    = var.blob_properties.cors_rule.allowed_headers
          allowed_methods    = var.blob_properties.cors_rule.allowed_methods
          allowed_origins    = var.blob_properties.cors_rule.allowed_origins
          exposed_headers    = var.blob_properties.cors_rule.exposed_headers
          max_age_in_seconds = var.blob_properties.cors_rule.max_age_in_seconds
        }
      }

      dynamic "delete_retention_policy" {
        for_each = var.blob_properties.delete_retention_policy == null || var.blob_properties.delete_retention_policy == {} ? [] : [1]
        content {
          days = var.blob_properties.delete_retention_policy.days == null ? 7 : var.blob_properties.delete_retention_policy.days == null
        }
      }

      versioning_enabled       = var.blob_properties.versioning_enabled
      change_feed_enabled      = var.blob_properties.change_feed_enabled
      default_service_version  = var.blob_properties.default_service_version
      last_access_time_enabled = var.blob_properties.last_access_time_enabled

      dynamic "container_delete_retention_policy" {
        for_each = var.blob_properties.container_delete_retention_policy == null || var.blob_properties.container_delete_retention_policy == {} ? [] : [1]
        content {
          days = var.blob_properties.container_delete_retention_policy.days == null ? 7 : var.blob_properties.container_delete_retention_policy.days
        }
      }

    }

  }


  dynamic "custom_domain" {
    for_each = var.custom_domain == null || var.custom_domain == {} ? [] : [1]
    content {
      name          = var.custom_domain.name
      use_subdomain = var.custom_domain.use_subdomain
    }
  }

  dynamic "queue_properties" {
    for_each = var.queue_properties == null || var.queue_properties == {} ? [] : [1]
    content {
      dynamic "cors_rule" {
        for_each = var.queue_properties.cors_rule == null || var.queue_properties.cors_rule == {} ? [] : [1]
        content {
          allowed_headers    = var.queue_properties.cors_rule.allowed_headers
          allowed_methods    = var.queue_properties.cors_rule.allowed_methods
          allowed_origins    = var.queue_properties.cors_rule.allowed_origins
          exposed_headers    = var.queue_properties.cors_rule.exposed_headers
          max_age_in_seconds = var.queue_properties.cors_rule.max_age_in_seconds
        }
      }

      dynamic "logging" {
        for_each = var.queue_properties.logging == null || var.queue_properties.logging == {} ? [] : [1]
        content {
          delete                = var.queue_properties.logging.delete
          read                  = var.queue_properties.logging.read
          version               = var.queue_properties.logging.version
          write                 = var.queue_properties.logging.write
          retention_policy_days = var.queue_properties.logging.retention_policy_days
        }
      }

      dynamic "minute_metrics" {
        for_each = var.queue_properties.minute_metrics == null || var.queue_properties.minute_metrics == {} ? [] : [1]
        content {
          enabled               = var.queue_properties.minute_metrics.enabled
          version               = var.queue_properties.minute_metrics.version
          include_apis          = var.queue_properties.minute_metrics.include_apis
          retention_policy_days = var.queue_properties.minute_metrics.retention_policy_days
        }
      }

      dynamic "hour_metrics" {
        for_each = var.queue_properties.hour_metrics == null || var.queue_properties.hour_metrics == {} ? [] : [1]
        content {
          enabled               = var.queue_properties.hour_metrics.enabled
          version               = var.queue_properties.hour_metrics.version
          include_apis          = var.queue_properties.hour_metrics.include_apis
          retention_policy_days = var.queue_properties.hour_metrics.retention_policy_days
        }
      }

    }
  }

  dynamic "static_website" {
    for_each = var.static_website == null || var.static_website == {} ? [] : [1]
    content {
      index_document     = var.static_website.index_document
      error_404_document = var.static_website.error_404_document
    }
  }
  # <TODO> : Add data block based lookup for subnet ids
  dynamic "network_rules" {
    for_each = var.network_rules == null || var.network_rules == {} ? [] : [1]
    content {
      default_action = var.network_rules.default_action == null ? "Allow" : var.network_rules.default_action
      bypass         = var.network_rules.bypass
      ip_rules       = var.network_rules.ip_rules
      virtual_network_subnet_ids = var.network_rules.virtual_network_subnet == null || var.network_rules.virtual_network_subnet == [] ? null : (
        [for instance in(var.network_rules.virtual_network_subnet == null || var.network_rules.virtual_network_subnet == [] ? [] : var.network_rules.virtual_network_subnet) : (
          instance.id == null ? (
            instance.name == null && instance.virtual_network_name == null ? (
              var.virtual_networks[instance.virtual_network_key].subnet[instance.key].id
            ) : "/subscriptions/${local.subscription_id}/resourceGroups/${instance.resource_group_name == null ? local.resource_group_name : instance.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${instance.virtual_network_name}/subnets/${instance.name}"
          ) : instance.id
          )
        ]
      )

      # <TODO> fix this and add data based lookup
      dynamic "private_link_access" {
        for_each = var.network_rules.private_link_access == null || var.network_rules.private_link_access == {} ? [] : [1]
        content {
          endpoint_resource_id = private_link_access.value.private_link_access.endpoint_resource_id == null ? (
            var.private_endpoints[private_link_access.value.private_link_access.endpoint_resource_key].private_endpoint_id
          ) : private_link_access.value.private_link_access.endpoint_resource_id
          endpoint_tenant_id = private_link_access.value.private_link_access.endpoint_tenant_id
        }
      }
    }
  }


  dynamic "azure_files_authentication" {
    for_each = var.azure_files_authentication == null || var.azure_files_authentication == {} ? [] : [1]
    content {
      directory_type = var.azure_files_authentication.directory_type
      dynamic "active_directory" {
        for_each = var.azure_files_authentication.active_directory == null ? [] : [1]
        content {
          storage_sid         = var.azure_files_authentication.active_directory.storage_sid
          domain_name         = var.azure_files_authentication.active_directory.domain_name
          domain_sid          = var.azure_files_authentication.active_directory.domain_sid
          domain_guid         = var.azure_files_authentication.active_directory.domain_guid
          forest_name         = var.azure_files_authentication.active_directory.forest_name
          netbios_domain_name = var.azure_files_authentication.active_directory.netbios_domain_name
        }
      }
    }
  }

  dynamic "routing" {
    for_each = var.routing == null || var.routing == {} ? [] : [1]
    content {
      publish_internet_endpoints  = var.routing.publish_internet_endpoints
      publish_microsoft_endpoints = var.routing.publish_microsoft_endpoints
      choice                      = var.routing.choice
    }
  }

}