# Create the VM Nic's

module "PaloAlto-mgmt-Network-Interfaces" {
  source                        = "../../../Network/Azure-NetworkInterface/1.0"
  for_each                      = { for instance in var.firewall-vm : instance.name => instance }
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
      private_ip_address = each.value.mgmt-private-ip-address
      primary            = true
    }
  ]
  loadbalancers   = var.loadbalancers
  resource_groups = var.resource_groups
}

module "PaloAlto-untrusted-Network-Interfaces" {
  source                        = "../../../Network/Azure-NetworkInterface/1.0"
  for_each                      = { for instance in var.firewall-vm : instance.name => instance }
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
      private_ip_address = each.value.untrusted-private-ip-address
      primary            = true
    }
  ]
  loadbalancers   = var.loadbalancers
  resource_groups = var.resource_groups
}

module "PaloAlto-trusted-Network-Interfaces" {
  source                        = "../../../Network/Azure-NetworkInterface/1.1"
  for_each                      = { for instance in var.firewall-vm : instance.name => instance }
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
      private_ip_address = each.value.trusted-private-ip-address
      primary            = true
      backend_address_pool = [{
        id = local.trusted-internal-loadbalancer-backend-address-pool-id
      }]
    }
  ]
  loadbalancers   = var.loadbalancers
  resource_groups = var.resource_groups
}


# Create the Linux Appliance VM
module "PaloAlto-Firewall-VMs" {
  source         = "../../../Compute/Azure-LinuxVirtualMachine/1.0"
  for_each       = { for instance in var.firewall-vm : instance.name => instance }
  name           = each.value.name
  resource_group = { tag = var.resource-group.tag }
  zone           = each.value.zone
  tags           = var.tags
  inherit_tags   = var.inherit_tags
  location       = local.location
  size           = each.value.size == null ? "Standard_E4s_v3" : each.value.size
  source_image_reference = {
    sku       = each.value.image-sku == null ? "byol" : each.value.image-sku
    publisher = each.value.image-publisher == null ? "paloaltonetworks" : each.value.image-publisher
    offer     = each.value.image-offer == null ? "vmseries1" : each.value.image-offer
    version   = each.value.image-version == null ? "latest" : each.value.image-version
  }
  plan = {
    name      = each.value.image-sku == null ? "byol" : each.value.image-sku
    publisher = each.value.image-publisher == null ? "paloaltonetworks" : each.value.image-publisher
    product   = each.value.image-offer == null ? "vmseries1" : each.value.image-offer
  }
  admin_username = var.admin-username
  admin_password = local.admin-password
  boot_diagnostics = {
    storage_account_uri  = null
    storage_account_name = var.diagnostics-storage-account
  }
  network_interface = [
    {
      id = module.PaloAlto-mgmt-Network-Interfaces[each.key].id
      # name = "${each.value.name}_nic03"
    },
    {
      id = module.PaloAlto-trusted-Network-Interfaces[each.key].id
      #name = "${each.value.name}_nic02"
    },
    {
      id = module.PaloAlto-untrusted-Network-Interfaces[each.key].id
      #name = "${each.value.name}_nic01"
    }
  ]
  resource_groups = var.resource_groups
}



module "PaloAlto-Firewall-VM-Backup" {
  source              = "../../../RecoveryServices/Azure-BackupProtectedVM/1.0"
  for_each            = { for instance in var.firewall-vm : instance.name => instance }
  resource_group      = { name = local.recovery_vault_resource_group_name }
  recovery_vault_name = local.recovery_vault_name
  source_vm           = { id = module.PaloAlto-Firewall-VMs[each.key].id }
  backup_policy       = { id = local.backup_policy_id }
}