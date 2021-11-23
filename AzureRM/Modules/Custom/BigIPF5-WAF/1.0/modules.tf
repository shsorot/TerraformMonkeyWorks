
# Create the VM Nic's

module "BigF5-mgmt-Network-Interfaces" {
  source                        = "../../../Network/Azure-NetworkInterface/1.0"
  for_each                      = { for instance in var.waf-vm : instance.name => instance }
  name                          = "${each.value.name}_nic03"
  resource_group                = { tag = var.resource-group.tag }
  location                      = local.location
  tags                          = var.tags
  inherit_tags                  = var.inherit_tags
  enable_accelerated_networking = true
  ip_configuration = [
    {
      name = "ipconfig1"
      subnet = {
        id = local.mgmt-subnet-id
      }
      private_ip_address    = each.value.mgmt-private-ip-address
      private_ip_allocation = "Static"
      primary               = true
    }
  ]
  dns_servers     = ["168.63.129.16"]
  loadbalancers   = var.loadbalancers
  resource_groups = var.resource_groups
}

module "BigF5-untrusted-Network-Interfaces" {
  source                        = "../../../Network/Azure-NetworkInterface/1.1"
  for_each                      = { for instance in var.waf-vm : instance.name => instance }
  name                          = "${each.value.name}_nic01"
  resource_group                = { tag = var.resource-group.tag }
  location                      = local.location
  tags                          = var.tags
  inherit_tags                  = var.inherit_tags
  enable_accelerated_networking = true
  ip_configuration = [
    {
      name = "ipconfig1"
      subnet = {
        id = local.untrusted-subnet-id
      }
      backend_address_pool = [{
        id = local.untrusted-internal-loadbalancer-backend-address-pool-id
        },
        {
          id = local.untrusted-external-loadbalancer-backend-address-pool-id
        }
      ]
      private_ip_address    = each.value.untrusted-private-ip-address
      private_ip_allocation = "Static"
      primary               = true
    }
  ]
  loadbalancers   = var.loadbalancers
  resource_groups = var.resource_groups
}

module "BigF5-trusted-Network-Interfaces" {
  source                        = "../../../Network/Azure-NetworkInterface/1.1"
  for_each                      = { for instance in var.waf-vm : instance.name => instance }
  name                          = "${each.value.name}_nic02"
  resource_group                = { tag = var.resource-group.tag }
  location                      = local.location
  tags                          = var.tags
  inherit_tags                  = var.inherit_tags
  enable_accelerated_networking = true
  ip_configuration = [
    {
      name = "ipconfig1"
      subnet = {
        id = local.trusted-subnet-id
      }
      private_ip_address    = each.value.trusted-private-ip-address
      private_ip_allocation = "Static"
      primary               = true
      backend_address_pool = [
        {
          id = local.untrusted-external-loadbalancer-backend-address-pool-id
        },
        {
          id = local.untrusted-internal-loadbalancer-backend-address-pool-id
        }
      ]
    }
  ]
  loadbalancers   = var.loadbalancers
  resource_groups = var.resource_groups
}



#Create the Linux Appliance VM
module "BigF5-waf-vms" {
  source         = "../../../Compute/Azure-LinuxVirtualMachine/1.0"
  for_each       = { for instance in var.waf-vm : instance.name => instance }
  name           = each.value.name
  resource_group = { tag = var.resource-group.tag }
  tags           = var.tags
  inherit_tags   = var.inherit_tags
  zone           = "1"
  location       = local.location
  size           = each.value.size == null ? "Standard_E4s_v3" : each.value.size
  source_image_reference = {
    sku       = each.value.image-sku == null ? "f5-big-all-1slot-byol" : each.value.image-sku
    publisher = each.value.image-publisher == null ? "f5-networks" : each.value.image-publisher
    offer     = each.value.image-offer == null ? "f5-big-ip-byol" : each.value.image-offer
    version   = each.value.image-version == null ? "latest" : each.value.image-version
  }
  plan = {
    name      = each.value.image-sku == null ? "f5-big-all-1slot-byol" : each.value.image-sku
    publisher = each.value.image-publisher == null ? "f5-networks" : each.value.image-publisher
    product   = each.value.image-offer == null ? "f5-big-ip-byol" : each.value.image-offer
  }
  admin_username = var.admin-username
  admin_password = local.admin-password
  boot_diagnostics = {
    storage_account_uri  = null
    storage_account_name = var.diagnostics-storage-account
  }
  network_interface = [
    {
      id = module.BigF5-mgmt-Network-Interfaces[each.key].id
    },
    {
      id = module.BigF5-trusted-Network-Interfaces[each.key].id
    },
    {
      id = module.BigF5-untrusted-Network-Interfaces[each.key].id
    }
  ]
  resource_groups = var.resource_groups
}


# <TODO> Configure VM backup
