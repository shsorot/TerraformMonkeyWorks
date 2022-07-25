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

#Data block used by ip_configuration->subnet_id

data "azurerm_subnet" "this" {
  for_each             = { for instance in var.ip_configuration : concat(instance.subnet.name, "-", instance.subnet.virtual_network_name) => instance.subnet if instance.subnet != null && instance.subnet.name != null && instance.private_ip_address_version != "IPv6" }
  name                 = each.value.name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = coalesce(each.value.resource_group_name, local.resource_group_name)
}


# Data block used by ip_configuation->public_ip_address_id
# for some reasons, terraform is not parsing multiple conditions in for loop 'if' sub statement, workaround implemented as nested if
data "azurerm_public_ip" "this" {
  for_each = { for instance in var.ip_configuration :
    instance.public_ip_address.name => instance.public_ip_address
    if(instance.public_ip_address == null || instance.public_ip_address == {} ? false : (instance.public_ip_address.name == null ? false : true))
  }
  name                = each.value.name
  resource_group_name = coalesce(each.value.resource_group_name, local.resource_group_name)
}

# Data block used by azurerm_network_interface_application_security_group_association.tf 
data "azurerm_application_security_group" "this" {
  for_each            = var.application_security_group == null || var.application_security_group == [] ? {} : { for instance in var.application_security_group : instance.name => instance if instance.name != null }
  name                = each.value.name
  resource_group_name = coalesce(each.value.resource_group_name, local.resource_group_name)
}

#Data block used by azurerm_network_interface_security_group_association.tf  
data "azurerm_network_security_group" "this" {
  count               = var.network_security_group == null || var.network_security_group == {} ? 0 : 1
  name                = var.network_security_group.name
  resource_group_name = coalesce(var.network_security_group.resource_group_name, local.resource_group_name)
}

# Data block used by IP Configuration -> gateway_load_balancer_frontend_ip_configuration_id & azurerm_network_interface_backend_address_pool_association.tf(backend pool needs load balancer ID)

# Due to limitation by Terraform, there is no data block available for frontend IP configuration, therefore ,we shall retrieve the Load balancer data object and extract frontend ID from one of it's sub-properties
# TODO : replace with data block for frontend IP configuration when released by Terraform AzureRM provider
# for some reasons, terraform is not parsing multiple conditions in for loop 'if' sub statement, workaround implemented as nested if
data "azurerm_lb" "this" {
  for_each = { for instance in var.ip_configuration :
    concat(instance.gateway_load_balancer_frontend_ip_configuration.load_balancer_name, "-", instance.gateway_load_balancer_frontend_ip_configuration.name) => instance.gateway_load_balancer_frontend_ip_configuration
    if(instance.gateway_load_balancer_frontend_ip_configuration == null || instance.gateway_load_balancer_frontend_ip_configuration == {} ? false : (instance.gateway_load_balancer_frontend_ip_configuration.name == null && instance.gateway_load_balancer_frontend_ip_configuration.load_balancer_name == null ? false : true))
  }
  name                = each.value.load_balancer_name
  resource_group_name = coalesce(each.value.resource_group_name, local.resource_group_name)
}

# # Data block used by azurerm_network_interface_backend_address_pool_association.tf code
data "azurerm_lb" "azurerm_network_interface_backend_address_pool_association"{
  for_each = { for instance in var.ip_configuration :
    concat(instance.backend_address_pool.load_balancer_name,"-",instance.backend_address_pool.name) => instance 
    if (instance.backend_address_pool == null || instance.backend_address_pool == {} ? false : (instance.backend_address_pool.name == null && instance.backend_address_pool.load_balancer_name == null ? false : true))
  }
  name                = each.value.load_balancer_name
  resource_group_name = coalesce(each.value.resource_group_name, local.resource_group_name) 
}

data "azurerm_lb_backend_address_pool" "azurerm_network_interface_backend_address_pool_association" {
  for_each = { for instance in var.ip_configuration :
    concat(instance.backend_address_pool.load_balancer_name,"-",instance.backend_address_pool.name) => instance 
    if (instance.backend_address_pool == null || instance.backend_address_pool == {} ? false : (instance.backend_address_pool.name == null && instance.backend_address_pool.load_balancer_name == null ? false : true))
  }
  name            = each.value.name
  loadbalancer_id = data.azurerm_lb.azurerm_network_interface_backend_address_pool_association[concat(each.value.backend_address_pool.load_balancer_name,"-",each.value.backend_address_pool.name)].id
}

locals {
  # load_balanced_ip_configuration = { for v in var.ip_configuration : v.name => v.backend_address_pool  if  v.backend_address_pool != null }
  # TODO : Add data based lookup
  load_balanced_ip_configuration = flatten([for v in var.ip_configuration :
    [for instance in v.backend_address_pool :
      {
        ip_configuration_name = v.name
        backend_address_pool_id = instance.id == null ? (
          instance.name == null && instance.load_balancer_name == null ? (
            var.loadbalancers[instance.loadbalancer_tag].backend_address_pool[instance.backend_pool_tag].id
          ) : data.azurerm_lb_backend_address_pool.azurerm_network_interface_backend_address_pool_association[concat(instance.backend_address_pool.load_balancer_name,"-",instance.backend_address_pool.name)].id
        ) : instance.id
      } if v.backend_address_pool == null 
    ]
  if(v.backend_address_pool != null && v.backend_address_pool != [])])

  # workaround for public IP addresses
  # public_ip_addresses = [ for instance in var.ip_configuration : instance. ]
  # TODO : test frontend ID lookup as output of data block is a list of object
  ip_configuration = [for instance in var.ip_configuration : {
    name = instance.name
    gateway_load_balancer_frontend_ip_configuration_id = instance.gateway_load_balancer_frontend_ip_configuration == null || instance.gateway_load_balancer_frontend_ip_configuration == {} ? null : (
      instance.gateway_load_balancer_frontend_ip_configuration.id == null ? (
        instance.gateway_load_balancer_frontend_ip_configuration.name == null && instance.gateway_load_balancer_frontend_ip_configuration.load_balancer_name == null ? (
          var.loadbalancers[instance.gateway_load_balancer_frontend_ip_configuration.load_balancer_name].frontend_ip_configuration[instance.gateway_load_balancer_frontend_ip_configuration.name].id
        ) : ({ for instance2 in data.azurerm_lb.this[instance.gateway_load_balancer_frontend_ip_configuration.name].frontend_ip_configurations : instance2.name => instance2 })[instance.gateway_load_balancer_frontend_ip_configuration.name].id
      ) : instance.gateway_load_balancer_frontend_ip_configuration.id
    )
    # IF null or IPv4, then use the subnet id
    subnet_id = instance.private_ip_address_version == "IPv4" || instance.private_ip_address_version == null ? (instance.subnet.id == null ? (
      instance.subnet.name == null && instance.subnet.virtual_network_name == null ? (
        var.virtual_networks[instance.subnet.virtual_network_key].subnet[instance.subnet.key].id
      ) : data.azurerm_subnet.this[concat(instance.subnet.name, "-", instance.subnet.virtual_network_name)].id
    ) : instance.subnet.id) : null
    # defaults to IPv4

    private_ip_address_version    = instance.private_ip_address_version == null ? "IPv4" : instance.private_ip_address_version
    private_ip_address_allocation = instance.private_ip_address_allocation == null ? "Dynamic" : instance.private_ip_address_allocation
    public_ip_address_id = instance.public_ip_address == null || instance.public_ip_address == {} ? null : (
      instance.public_ip_address.id == null ? (
        instance.public_ip_address.name == null ? (
          var.public_ip_addresses[instance.public_ip_address.key].id
        ) : data.azurerm_public_ip.this[instance.public_ip_address.name].id
      ) : instance.public_ip_address.id
    )
    primary            = instance.primary
    private_ip_address = instance.private_ip_address_allocation == "Static" ? instance.private_ip_address_allocation : null
  }]


  application_security_group_ids = var.application_security_group == null || var.application_security_group == [] ? null : (
    [for instance in var.application_security_group : (instance.id == null ? (
      instance.name == null ? (
        var.application_security_groups[instance.key].id
      ) : data.azurerm_application_security_group.this[instance.name].id
    ) : instance.id)]
  )

  network_security_group_id = var.network_security_group == null || var.network_security_group == {} ? null : (
    var.network_security_group.id == null ? (
      var.network_security_group.name == null ? (
        var.network_security_groups[var.network_security_group.key].id
      ) : data.azurerm_network_security_group.this[0].id
    ) : var.network_security_group
  )
}