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
  resource_group_name     = var.resource_group.name == null ? var.resource_groups[var.resource_group.key].name : data.azurerm_resource_group.this[0].name
  resource_group_tags     = var.resource_group.name == null ? var.resource_groups[var.resource_group.key].tags : data.azurerm_resource_group.this[0].tags
  tags                    = merge(var.tags, (var.inherit_tags == true ? local.resource_group_tags : {}))
  resource_group_location = var.resource_group.name == null ? var.resource_groups[var.resource_group.key].location : data.azurerm_resource_group.this[0].location
  location                = var.location == null ? local.resource_group_location : var.location
}

# blocks for user assigned identities when var.identity.type == "SystemAssigned"
data "azurerm_user_assigned_identity" "this" {
  for_each            = var.identity == null ? {} : { for instance in(var.identity.type == "SystemAssigned" ? [] : var.identity.identity) : instance.name => instance if instance.name != null }
  name                = each.key
  resource_group_name = coalesce(each.value.resource_group_name, local.resource_group_name)
}


# Block for azure dedicated hosts 
data "azurerm_dedicated_host" "this" {
  count                     = var.dedicated_host == null ? 0 : (var.dedicated_host.name == null && var.dedicated_host.dedicated_host_group_name == null ? 0 : 1)
  name                      = var.dedicated_host.name
  resource_group_name       = coalesce(var.dedicated_host.resource_group_name, local.resource_group_name)
  dedicated_host_group_name = var.dedicated_host.dedicated_host_group_name
}

# Block for azure dedicated host groups 
data "azurerm_dedicated_host_group" "this" {
  count               = var.dedicated_host_group == null ? 0 : (var.dedicated_host.name == null ? 0 : 1)
  name                = var.dedicated_host_group.name
  resource_group_name = coalesce(var.dedicated_host_group.resource_group_name, local.resource_group_name)
}

# Block for availability set lookup
data "azurerm_availability_set" "this" {
  count               = var.availability_set == null ? 0 : (var.availability_set.name == null ? 0 : 1)
  name                = var.availability_set.name
  resource_group_name = coalesce(var.availability_set.resource_group_name, local.resource_group_name)
}

# Block for PPG lookup
data "azurerm_proximity_placement_group" "this" {
  count               = var.proximity_placement_group == null ? 0 : (var.proximity_placement_group.name == null ? 0 : 1)
  name                = var.proximity_placement_group.name
  resource_group_name = coalesce(var.proximity_placement_group.resource_group_name, local.resource_group_name)
}

# Block for disk encryption set lookup
data "azurerm_disk_encryption_set" "this" {
  count               = var.os_disk.disk_encryption_set == null ? 0 : (var.os_disk.disk_encryption_set.name == null ? 0 : 1)
  name                = var.os_disk.disk_encryption_set.name
  resource_group_name = coalesce(var.os_disk.disk_encryption_set.resource_group_name, local.resource_group_name)
}

# Block for secret and winrm_listener(dependency) blocks
data "azurerm_key_vault" "this" {
  for_each = { for instance in local.merged_certificates_list : instance.key_vault_name => instance if instance.key_vault_name != null }
  name                 = each.value.key_vault_name
  resource_group_name  = each.value.key_vault_resource_group_name
}

# Block for secret and winrm_listener blocks
data "azurerm_key_vault_certificate" "this"{
  for_each = { for instance in local.merged_certificates_list : instance.certificate_name => instance if instance.certificate_name != null}
  name     = each.value.certificate_name
  key_vault_id = each.value.key_vault_id == null ? (
    each.value.key_vault_name == null ? (
       var.key_vaults[each.value.key_vault_key].id
    ) : data.azurerm_key_vault.this[each.value.key].id
  ) : each.value.key_vault_id
}

# Block for "virtual_machine_scale_set_id" variable generation
data "azurerm_virtual_machine_scale_set" "this" {
  count               = var.virtual_machine_scale_set == null ? 0 : (var.virtual_machine_scale_set.name == null ? 0 : 1)
  name                = var.virtual_machine_scale_set.name
  resource_group_name = coalesce(var.virtual_machine_scale_set.resource_group_name, local.resource_group_name)
}

data "azurerm_network_interface" "this" {
  for_each            = { for instance in var.network_interface : instance.name => instance if instance.name != null }
  name                = each.key
  resource_group_name = coalesce(each.value.resource_group_name, local.resource_group_name)
}

# Block for azure image lookup for source_image_id
data "azurerm_image" "this" {
  count               = var.source_image == null || var.source_image == {} ? 0 : ( var.source_image.name == null ? 0 : 1)
  name              = var.source_image.name
  resource_group_name = coalesce(var.source_image.resource_group_name,local.resource_group_name)
}

locals {

  # # Consolidated variable object for certificate url from secrets and winrm_listener to simplify the data blocks for keyvault and certificates
  merged_secret_certificates_list = flatten(var.secret == null || var.secret == [] ? [] : (
    [ for instance1 in var.secret : 
      [for instance2 in instance1.certificate : {
        key_vault_name = instance1.key_vault.name
        key_vault_resource_group_name = coalesce(instance1.key_vault.resource_group_name,local.resource_group_name)
        key_vault_id = instance1.key_vault.id
        key_vault_key = instance1.key_vault.key
        certificate_name = instance2.url.name
        certificate_id = instance2.url.id
        certificate_key = instance2.url.key
        }
      ] 
    ]
  ))
  merged_winrm_certificates_list =  flatten(var.winrm_listener == null || var.winrm_listener == [] ? [] : (
    [ for instance in var.winrm_listener : 
      {
        key_vault_name = instance.certificate.url.key_vault_name
        key_vault_resource_group_name = coalesce(instance.certificate.url.key_vault_resource_group_name,local.resource_group_name)
        key_vault_id = instance.certificate.url.key_vault_id
        key_vault_key = instance.certificate.url.key_vault_key
        certificate_name = instance.certificate.url.name
        certificate_id = instance.certificate.url.id
        certificate_key = instance.certificate.url.key
      } if instance.protocol == "https"
    ]
  ))

  # common list of all keyvaults and certificates used in this module. Simpifies lookup as multiple blocks can lookup certificate url's & keyvault ID from a single list of objects
  merged_certificates_list = distinct(concat(distinct(local.merged_secret_certificates_list),distinct(local.merged_winrm_certificates_list)))
  
  # custom user data, can be provided as raw value or base64 encoded file
  user_data = var.user_data == null || var.user_data == {} ? null : (
    var.user_data.raw == null ? (
      var.user_data.file == null ? null : filebase64(var.user_data.file)
    ) : var.user_data.raw
  )

  dedicated_host_id = var.dedicated_host == null ? null : (
    var.dedicated_host.id == null ? (
      var.dedicated_host.name == null && var.dedicated_host.dedicated_host_group_name == null ? (
        var.dedicated_hosts[var.dedicated_host.key].id
      ) : data.azurerm_dedicated_host.this[0].id
    ) : var.dedicated_host.id
  )

  dedicated_host_group_id = var.dedicated_host_group == null ? null : (
    var.dedicated_host_group.id == null ? (
      var.dedicated_host_group.name == null ? (
        var.dedicated_host_groups[var.dedicated_host_group.key].id
      ) : data.azurerm_dedicated_host_group.this[0].id
    ) : var.dedicated_host_group.id
  )

  availability_set_id = var.availability_set == null ? null : (
    var.availability_set.id == null ? (
      var.availability_set.name == null ? (
        var.availability_sets[var.availability_set.key].id
      ) : data.azurerm_availability_set.this[0].id
    ) : var.availability_set.id
  )

  proximity_placement_group_id = var.proximity_placement_group == null ? null : (
    var.proximity_placement_group.id == null ? (
      var.proximity_placement_group.name == null ? (
        var.proximity_placement_group[var.proximity_placement_group.key].id
      ) : data.azurerm_proximity_placement_group.this[0].id
    ) : var.proximity_placement_group.id
  )


  disk_encryption_set_id = var.os_disk.disk_encryption_set == null ? null : (
    var.os_disk.disk_encryption_set.id == null ? (
      var.os_disk.disk_encryption_set.name == null ? (
        var.disk_encryption_sets[var.os_disk.disk_encryption_set.key].id
      ) : data.azurerm_disk_encryption_set.this[0].id
    ) : var.os_disk.disk_encryption_set_id
  )

  secret = var.secret == null || var.secret == [] ? [] : [
    for instance in var.secret : {
      key_vault_id = instance.value.key_vault.id == null ? (
        instance.value.key_vault.name == null ? (
          var.key_vaults[instance.value.key_vault.key].id
        ) : data.azurerm_key_vault.this[instance.value.key_vault.name].id
      ) : instance.value.key_vault.id
      certificate = [ for certificate in instance.value.certificate : {
        url = certificate.url.id == null ? (
          certificate.url.name == null ? (
            data.azurerm_key_vault_certificate.this[certificate.url.name].secret_id
          ) : data.azurerm_key_vault_certificate.this[certificate.url.name].secret_id
        ) : certificate.url.id
        store = certificate.store
        } 
      ]
    }]


  # Note that Orchestrated Virtual Machine Scale Sets, Virtual Machine Scale Sets & Windows/Linux Virtual Machine Scale Sets are all the same 
  # in the sense that they are all represented by the same data source. Terraform treats them different due to the fact that they have different
  # OS and orchestration types
  virtual_machine_scale_set_id = var.virtual_machine_scale_set == null || var.virtual_machine_scale_set == {} ? null : (
    var.virtual_machine_scale_set.id == null ? (
      var.virtual_machine_scale_set.name == null ? (
        var.virtual_machine_scale_sets[var.virtual_machine_scale_set.key].id
        ) : data.azurerm_virtual_machine_scale_set.this[0].id
    ) : var.virtual_machine_scale_set.id
  )

  network_interface_ids = [for instance in var.network_interface : (
    instance.id == null ? (
      instance.name == null ? (
        var.network_interfaces[instance.key].id
      ) : data.azurerm_network_interface.this[instance.name].id
    ) : instance.id
  )]


  source_image_reference = var.source_image_reference == null ? {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  } : var.source_image_reference

  # When an admin_password is specified disable_password_authentication must be set to false.
  disable_password_authentication = var.admin_password != null ? false : var.disable_password_authentication

  identity = var.identity == null ? null : (
    {
      type = var.identity.type
      identity_ids = var.identity.type == "UserAssigned" ? (
        [for instance in var.identity.identity : (
          instance.id == null ? (
            instance.name == null ? (
              var.user_assigned_identities[instance.key].id
            ) : data.azurerm_user_assigned_identity.this[instance.name].id
          ) : instance.id
        )]
      ) : null
    }
  )


  source_image_id = var.source_image == null || var.source_image == {} ? null : (
    var.source_image.id == null ? (
      var.source_image.name == null ? (
        var.azure_images[var.source_image.key].id
      ) : data.azurerm_image.this[var.source_image.name].id
    ) : var.source_image.id
  )

  custom_data = var.custom_data == null || var.custom_data == {} ? null : (
    var.custom_data.raw == null ? filebase64(var.custom_data.file) : var.custom_data.raw
  )

  winrm_listener = var.winrm_listener == null || var.winrm_listener == {} ? null : (
    [ for instance in var.winrm_listener : {
        protocol = instance.protocol
        certificate_url = instance.certificate.url.id == null ? (
          instance.certificate.url.name == null && instance.certificate.url.key_vault_name == null ? (
            var.key_vault_certificates[instance.certificate.url.key].secret_id
          ) : data.azurerm_resource_group.this[instance.certificate.url.key].secret_id
        ) : instance.certificate.url.id
      }
    ]
  )

  # Local variable for network interfaces
  # Multiple blocks, Mandatory minimum 1
  network_interface = { for idx,instance in var.network_interface: instance.name =>{
    name = instance.name
    ip_configuration = { for instance2 in instance.ip_configuration : instance2.name => {
      name = instance2.name
      
    } }
    dns_Servers = instance.dns_servers
    enable_accelerated_networking = instance.enable_accelerated_networking
    enable_ip_forwarding = instance.enable_ip_forwarding
    network_security_group_id = instance.network_security_group.id == null ? (
      instance.network_security_group.name == null ? (
        var.nework_security_groups[instance.network_security_group.key].id
      ) : data.azurerm_network_security_group.this[instance.name].id
    ) : instance.network_security_group.id
    # TODO : logic based lookup and auto assign primary property
    primary = instance.primary
  }}
}


data "azurerm_network_security_group" "this"{
  for_each = { for idx,instance in var.network_interface: instance.name =>instance.network_security_group if (instance.network_security_group != null || instance.network_security_group != {} ? (instance.network_security_group.name != null ? true : false) : false) }
  name = instance.network_security_group.name
  resource_group_name = coalesce(instance.network_security_group.resource_group_name,local.resource_group_name)
}

