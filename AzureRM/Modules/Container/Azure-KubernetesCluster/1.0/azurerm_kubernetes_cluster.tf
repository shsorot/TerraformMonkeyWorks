
# Note that due to the nature of terraform, all secrets will be stored in plain text in state file for this resource type

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = local.tags
  # Required, Single block
  # If you're using AutoScaling subproperty, you may wish to use Terraform's ignore_changes functionality to ignore changes to the node_count field to prevent unexpected service disruptions.
  default_node_pool {
    name = var.default_node_pool.name
    vm_size = var.default_node_pool.vm_size
    enable_auto_scaling = var.default_node_pool.enable_auto_scaling  #This requires that the type is set to VirtualMachineScaleSets.
    enable_host_encryption = var.default_node_pool.enable_host_encryption
    enable_node_public_ip = var.default_node_pool.enable_node_public_ip
    # Optional, single block
    dynamic "kubelet_config" {
      for_each = var.default_node_pool.kubelet_config == null || var.default_node_pool.kubelet_config == {} ? [] : [1]
      dynamic {
        
      }
    }
    # Optional, single block
    dynamic "linux_os_config"{

    }
    kubelet_disk_type = var.default_node_pool.kubelet_disk_type
    max_pods = var.default_node_pool.max_pods
    # TODO:
    node_public_ip_prefix_id = null

  }
  #One of dns_prefix or dns_prefix_private_cluster must be specified.
  dns_prefix = var.dns_prefix
  #The dns_prefix must contain between 3 and 45 characters, and can contain only letters, numbers, and hyphens. It must start with a letter and must end with a letter or a number.
  dns_prefix_private_cluster = var.dns_prefix_private_cluster

  # Optional , Single block
  # Ensure that subnet being specified here has a delegation " actions = ["Microsoft.Network/virtualNetworks/subnets/action"]" added in any previous network code to prevent failure post refresh
  dynamic "aci_connector_linux" {
    for_each  = var.aci_connector_linux == null || var.aci_connector_linux == {} ? [] : [1]
    dynamic {
      subnet_name = var.aci_connector_linux.subnet_name
    }
  }
  #Cluster Auto-Upgrade will update the Kubernetes Cluster (and its Node Pools) to the latest GA version of Kubernetes automatically - please see the Azure documentation for more information.
  automatic_channel_upgrade = var.automatic_channel_upgrade
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges
  
  # Optional, Single block
  dynamic "auto_scaler_profile"{
    for_each = var.auto_scaler_profile == null  || var.auto_scaler_profile == {} ? [] : [1]
    dynamic {
      balance_similar_node_groups = try(var.auto_scaler_profile.balance_similar_node_groups,false)
      expander = try(var.auto_scaler_profile.expander, "random")
      max_graceful_termination_sec = try(var.auto_scaler_profile.max_graceful_termination_sec, 600)
      max_node_provisioning_time = try(var.auto_scaler_profile.max_node_provisioning_time, "15m")
      max_unready_nodes = try(var.auto_scaler_profile.max_unready_nodes, 3)
      max_unready_percentage = try(var.auto_scaler_profile.max_unready_percentage,3)
      new_pod_scale_up_delay = try(var.auto_scaler_profile.new_pod_scale_up_delay,"10s")
      scale_down_delay_after_add = try(var.auto_scaler_profile.scale_down_delay_after_add,"10m")
      scale_down_delay_after_delete = try(var.auto_scaler_profile.scale_down_delay_after_delete,"10m")
      scale_down_delay_after_failure = try(var.auto_scaler_profile.scale_down_delay_after_failure, "3m")
      scan_interval = try(var.auto_scaler_profile.scan_interval,"10s")
      scale_down_unneeded = try(var.auto_scaler_profile.scale_down_unneeded,"10m")
      scale_down_unready = try(var.auto_scaler_profile.scale_down_unready,"20m")
      scale_down_utilization_threshold = try(var.auto_scaler_profile.scale_down_utilization_threshold, 0.5)
      empty_bulk_delete_max = try(var.auto_scaler_profile.empty_bulk_delete_max,10)
      skip_nodes_with_local_storage = try(var.auto_scaler_profile.skip_nodes_with_local_storage,true)
      skip_nodes_with_system_pods = try(var.auto_scaler_profile.skip_nodes_with_system_pods,true)
    }
  }

  # Optional, Single block
  # TODO, lookup for IDs
  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.azure_active_directory_role_based_access_control == null || azure_active_directory_role_based_access_control == {} ? [] : [1]
    dynamic {
      managed = var.azure_active_directory_role_based_access_control.managed
      tenant_id = var.azure_active_directory_role_based_access_control.tenant_id
      admin_group_object_ids = var.azure_active_directory_role_based_access_control.admin_group_object_ids
      azure_rbac_enabled = var.azure_active_directory_role_based_access_control.azure_rbac_enabled
      client_app_id = var.azure_active_directory_role_based_access_control.client_app_id
      server_app_id = var.azure_active_directory_role_based_access_control.server_app_id
      server_app_secret = var.azure_active_directory_role_based_access_control.server_app_secret
    }
  }

  azure_policy_enabled = var.azure_policy_enabled
  disk_encryption_set_id = local.disk_encryption_set_id
  http_application_routing_enabled = var.http_application_routing_enabled

  # Optional, Single block
  dynamic "http_proxy_config" {
    for_each = var.http_proxy_config == null || var.http_proxy_config == {} ? [] : [1]
    dynamic {
      http_proxy = var.http_proxy_config.http_proxy
      https_proxy = var.http_proxy_config.https_proxy
      #If you specify the default_node_pool.0.vnet_subnet_id, be sure to include the Subnet CIDR in the no_proxy list.
      no_proxy = var.http_proxy_config.no_proxy
      trusted_ca = var.http_proxy_config.trusted_ca
    }
  }
  
  # Optional, Single block
  # NOTE:
  # A migration scenario from service_principal to identity is supported. 
  # When upgrading service_principal to identity, your cluster's control plane and addon pods will switch to use managed identity, 
  # but the kubelets will keep using your configured service_principal until you upgrade your Node Pool.
  # Either Identity of Service principal must be specified but not both.enable_pod_security_policy = 
  dynamic "identity"{
    for_each = local.identity == null ? [] : [1]
    dynamic {
      type = local.identity.type
      identity_ids = local.identity.type == "UserAssigned" ? local.identity.identity_ids : null
    }
  }

  # Optional, Single block
  # If specifying ingress_application_gateway in conjunction with default_node_pool->only_critical_addons_enabled, the AGIC pod will fail to start. 
  # A separate azurerm_kubernetes_cluster_node_pool is required to run the AGIC pod successfully. 
  # This is because AGIC is classed as a "non-critical addon".
  # TODO : add a check to drop this block if default_node_pool->only_critical_addons_enabled is used
  dynamic "ingress_application_gateway" {
    for_each = local.ingress_application_gateway == null || local.ingress_application_gateway == {} ? [] : [1]
    dynamic {
      gateway_id = local.gateway_id
      gateway_name = local.gateway_name
      subnet_cidr = local.subnet_cidr
      subnet_id = local.subnet_id
    }
  }

  # Optional, Single block
  dynamic "key_vault_secrets_provider"{
    for_each = var.key_vault_secrets_provider == null || var.key_vault_secrets_provider == {} ? [] : [1]
    dynamic {
      secret_rotation_enabled = var.key_vault_secrets_provider.secret_rotation_enabled
      secret_rotation_interval = var.key_vault_secrets_provider.secret_rotation_interval
    }
  }

  # Optional, Single Block
  dynamic "kubelet_identity"{
    for_each = var.kubelet_identity == null || var.kubelet_identity == {} ? [] : [1]
    dynamic {
      allowed_unsafe_sysctls = var.kubelet_identity.allowed_unsafe_sysctls
      container_log_max_line = var.kubelet_identity.container_log_max_line
      container_log_max_size_mb = var.kubelet_identity.container_log_max_size_mb
      cpu_cfs_quota_enabled = var.kubelet_identity.cpu_cfs_quota_enabled
      cpu_cfs_quota_period = var.kubelet_identity.cpu_cfs_quota_period
    }
  }

  kubernetes_version = var.kubernetes_version
  
  # Optional, Single Block
  dynamic "linux_profile" {
    
  }
  # If local_account_disabled is set to true, it is required to enable Kubernetes RBAC and AKS-managed Azure AD integration. 
  # See the documentation for more information.
  local_account_disabled = var.local_account_disabled

  # Optional, Single Block
  maintenance_window {
    
  }

  # Optional, Single Block
  microsoft_defender {
    
  }

  # Optional, Single Block
  network_profile {
    
  }

  node_resource_group = var.node_resource_group
  oidc_issuer_enabled = var.oidc_issuer_enabled
  # Optional, Single Block
  oms_agent {
    
  }

  open_service_mesh_enabled = var.open_service_mesh_enabled
  private_cluster_enabled = var.private_cluster_enabled
  private_dns_zone_id = local.private_dns_zone_id
  #This requires that the Preview Feature Microsoft.ContainerService/EnablePrivateClusterPublicFQDN is enabled and the Resource Provider is re-registered, see the documentation for more information.
  #If you use BYO DNS Zone, AKS cluster should either use a User Assigned Identity or a service principal (which is deprecated) with the Private DNS Zone Contributor role and access to this Private DNS Zone. 
  #If UserAssigned identity is used - to prevent improper resource order destruction - cluster should depend on the role assignment, like in this example:
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled
  role_based_access_control_enabled = var.role_based_access_control_enabled
  run_command_enabled = var.run_command_enabled
  # Optional, Single Block
  service_principal {
    
  }

  sku_tier = var.sku_tier
  # Optional, Single Block
  windows_profile {
    
  }
}