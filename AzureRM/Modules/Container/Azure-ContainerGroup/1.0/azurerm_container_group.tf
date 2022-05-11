resource "azurerm_container_group" "this" {
  name                = var.name
  location            = local.location
  resource_group_name = local.resource_group_name
  os_type             = var.os_type

  # If os_type == Windows, only single container is accepted. Windows containers are not supported in virtual networks.
  dynamic "container" {
    for_each = { for idx, instance in local.container : idx => instance }
    content {
      name   = container.value.name
      image  = container.value.image
      cpu    = container.value.cpu
      memory = container.value.memory
      # Single block for GPU allocation, only supported for linux
      dynamic "gpu" {
        for_each = container.value.gpu != null && var.os_type == "Linux" ? [1] : []
        content {
          count = container.value.gpu.count
          sku   = container.value.gpu.sku
        }
      }
      dynamic "ports" {
        for_each = { for idx, instance in var.container.ports : idx => instance if var.container.ports != null || var.container.ports != {} }
        content {
          port     = ports.value.port
          protocol = ports.value.protocol
        }
      }
      environment_variables        = each.value.environment_variables
      secure_environment_variables = each.value.secure_environment_variables
      # Single block
      dynamic "readiness_probe" {
        for_each = container.value.readiness_probe != null ? [1] : []
        content {
          exec = container.value.readiness_probe.exec
          # single block
          dynamic "http_get" {
            for_each = container.value.readiness_probe.http_get != null ? [1] : []
            content {
              path   = container.value.readiness_probe.http_get.path
              port   = container.value.readiness_probe.http_get.port
              scheme = container.value.readiness_probe.http_get.scheme
            }
          }
          initial_delay_seconds = container.value.readiness_probe.initial_delay_seconds
          period_seconds        = container.value.readiness_probe.period_seconds
          failure_threshold     = container.value.readiness_probe.failure_threshold
          success_threshold     = container.value.readiness_probe.success_threshold
          timeout_seconds       = container.value.readiness_probe.timeout_seconds
        }
      }
      # Single block
      dynamic "liveness_probe" {
        for_each = container.value.liveness_probe != null ? [1] : []
        content {
          exec = container.value.liveness_probe.exec
          # single block
          dynamic "http_get" {
            for_each = container.value.liveness_probe.http_get != null ? [1] : []
            content {
              path   = container.value.liveness_probe.http_get.path
              port   = container.value.liveness_probe.http_get.port
              scheme = container.value.liveness_probe.http_get.scheme
            }
          }
          initial_delay_seconds = container.value.liveness_probe.initial_delay_seconds
          period_seconds        = container.value.liveness_probe.period_seconds
          failure_threshold     = container.value.liveness_probe.failure_threshold
          success_threshold     = container.value.liveness_probe.success_threshold
          timeout_seconds       = container.value.liveness_probe.timeout_seconds
        }
      }
      commands = each.value.commands
      # Single block
      dynamic "volume" {
        for_each = container.value.volume != null ? [1] : []
        content {
          name                 = container.value.volume.name
          mount_path           = container.value.volume.mount_path
          read_only            = container.value.volume.read_only
          empty_dir            = container.value.volume.empty_dir
          storage_account_name = container.value.volume.storage_account_name
          storage_account_key  = container.value.volume.storage_account_key
          share_name           = container.value.volume.share_name
          # single block within child block
          dynamic "git_repo" {
            for_each = container.value.volume.git_repo != null ? [1] : []
            content {
              url       = container.value.volume.git_repo.url
              directory = container.value.volume.git_repo.directory
              revision  = container.value.volume.git_repo.revision
            }
          }
          # Base64 encoded map of secrets to inject into the container
          secret = container.value.volume.secret
        }
      }
    }
  }
  # Single block
  # TODO: add lookup code in local.tf as enhancement
  dynamic "identity" {
    for_each = var.identity != null ? [1] : []
    content {
      type         = var.identity[0].type
      identity_ids = var.identity[0].identity_ids
    }
  }

  # Single block
  dynamic "init_container" {
    for_each = var.init_container != null ? [1] : []
    content {
      name                         = var.init_container.name
      image                        = var.init_container.image
      environment_variables        = var.init_container.environment_variables
      secure_environment_variables = var.init_container.secure_environment_variables
      commands                     = var.init_container.commands
      # Single block within main block
      dynamic "volume" {
        for_each = var.init_container.volume != null ? [1] : []
        content {
          name                 = var.init_container.volume.name
          mount_path           = var.init_container.volume.mount_path
          read_only            = var.init_container.volume.read_only
          empty_dir            = var.init_container.volume.empty_dir
          storage_account_name = var.init_container.volume.storage_account_name
          storage_account_key  = var.init_container.volume.storage_account_key
          share_name           = var.init_container.volume.share_name
          # single block within child block
          dynamic "git_repo" {
            for_each = var.init_container.volume.git_repo != null ? [1] : []
            content {
              url       = var.init_container.volume.git_repo.url
              directory = var.init_container.volume.git_repo.directory
              revision  = var.init_container.volume.git_repo.revision
            }
          }
          # Base64 encoded map of secrets to inject into the container
          secret = var.init_container.volume.secret
        }
      }
    }
  }

  # Single Block
  dynamic "dns_config" {
    for_each = var.dns_config != null ? [1] : []
    content {
      nameservers    = var.dns_config.nameservers
      search_domains = var.dns_config.search_domainss
      options        = var.dns_config.options
    }
  }


  # TODO : add data/code block lookup for log analytics workspace ID for name/tag based lookup
  # Single block
  dynamic "diagnostics" {
    for_each = var.diagnostics != null ? [1] : []
    content {
      # Single block
      dynamic "log_analytics" {
        for_each = var.diagnostics.log_analytics != null ? [1] : []
        content {
          workspace_id  = var.diagnostics.log_analytics.workspace_id
          workspace_key = var.diagnostics.log_analytics.workspace_key
          log_type      = var.diagnostics.log_analytics.log_type
          metadata      = var.diagnostics.log_analytics.metadata
        }
      }
    }
  }

  dns_name_label = var.dns_name_label

  # TODO 
  # Removing all exposed_port blocks requires setting exposed_port = [].
  # currently not possible to remove once assigned from TF Code as dynamic and [] cannot co-exist
  # Single block
  dynamic "exposed_port" {
    for_each = var.exposed_port != null ? [1] : []
    content {
      port     = var.exposed_port.port
      protocol = var.exposed_port.protocol
    }
  }

  # dns_name_label and os_type set to windows are not compatible with Private ip_address_type
  # Public, Private or None. Changing this forces a new resource to be created. 
  # If set to Private, network_profile_id also needs to be set.
  ip_address_type    = var.ip_address_type
  network_profile_id = var.network_profile_id

  # single block
  dynamic "image_registry_credential" {
    for_each = var.image_registry_credential != null ? [1] : []
    content {
      username = var.image_registry_credential.username
      password = var.image_registry_credential.password
      server   = var.image_registry_credential.server
    }
  }
  restart_policy = var.restart_policy
  tags           = local.tags
}