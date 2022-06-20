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

# Block for key vault lookup (for secret block )
data "azurerm_key_vault" "this" {
  for_each            = var.secret == null || var.secret == [] ? {} : { for instance in var.secret.keyvault : instance.name => instance if instance.name != null }
  name                = each.key
  resource_group_name = coalesce(each.value.resource_group_name, local.resource_group_name)
}

# Block for certificate sub block within secret block
data "azurerm_key_vault_certificate" "this"{
  for_each            = var.secret == null || var.secret == []? {} : (
    [ for instance in var.secret: [for certificate in instance.certificate : { 
          key_vault = instance.key_vault
          url = certificate.url 
       }if certificate.url.name != null]
    ]
  )
  name                = each.value.url.name
  key_vault_id        = each.value.url.key_vault.id == null ? (
    each.value.key_vault.name == null ? (
      var.key_vaults[each.value.key_vault.key].id
    ) : data.azurerm_key_vault.this[each.value.key_vault.name].id
  ) : each.value.url.key_vault.id
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

  # Todo : Add lookup for certificate ID in certificate block ( containing url )
  # secret = var.secret == null ? [] : [for instance in var.secret : {
  #   certificate = instance.value.certificate
  #   keyvault_id = instance.value.keyvault.id == null ? (
  #     instance.value.keyvault.name == null ? (
  #       var.key_vaults[instance.value.keyvault.key].id
  #     ) : data.azurerm_key_vault.this[instance.value.keyvault.name].id
  #   ) : instance.value.keyvault.id
  # }]

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
            data.azurerm_key_vault_certificate.this[certificate.url.name].id
          ) : data.azurerm_key_vault_certificate.this[certificate.url.name].id
        ) : certificate.url.id
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
}