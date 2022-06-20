variable "PaloAltoExternalFirewalls" {
  default = {}
}

module "PaloAlto-External-Firewall" {
  source   = "../../../AzureRM/Modules/Custom/PaloAlto-ExternalFirewall/1.0"
  for_each = var.PaloAltoExternalFirewalls
  location = each.value.location
  # virtual-machine-resource-group-name     =   each.value.virtual-machine-resource-group-name
  # virtual-network-name                    =   each.value.virtual-network-name
  # virtual-network-resource-group-name     =   each.value.virtual-network-resource-group-name
  resource-group        = each.value.resource-group
  virtual-network       = each.value.virtual-network
  trusted-subnet-name   = each.value.trusted-subnet-name
  untrusted-subnet-name = each.value.untrusted-subnet-name
  mgmt-subnet-name      = each.value.mgmt-subnet-name
  # trusted-internal-loadbalancer           =   each.value.trusted-internal-loadbalancer
  trusted-internal-loadbalancer                           = each.value.trusted-internal-loadbalancer
  trusted-internal-loadbalancer-backend-address-pool-name = each.value.trusted-internal-loadbalancer-backend-address-pool-name
  firewall-vm                                             = each.value.firewall-vm
  # credential-keyvault-name                =   each.value.credential-keyvault-name
  # credential-keyvault-resource-group-name =   each.value.credential-keyvault-resource-group-name
  keyvault                    = each.value.keyvault
  admin-username              = each.value.admin-username
  admin-password              = try(each.value.admin-password, null)
  diagnostics-storage-account = each.value.diagnostics-storage-account
  backup_policy               = each.value.backup_policy
  virtual_networks            = module.Landscape-Virtual-Networks
  loadbalancers               = module.Landscape-Consolidated-Loadbalancers
  keyvaults                   = module.Landscape-Key-Vaults
  resource_groups             = module.Landscape-Resource-Groups
  backup_policies             = module.Landscape-Backup-Policy-VMs
}



variable "PaloAltoInternalFirewalls" {
  default = {}
}

module "PaloAlto-Internal-Firewall" {
  source   = "../../../AzureRM/Modules/Custom/PaloAlto-InternalFirewall/1.0"
  for_each = var.PaloAltoInternalFirewalls
  location = each.value.location
  # virtual-machine-resource-group-name     =   each.value.virtual-machine-resource-group-name
  # virtual-network-name                    =   each.value.virtual-network-name
  # virtual-network-resource-group-name     =   each.value.virtual-network-resource-group-name
  resource-group      = each.value.resource-group
  virtual-network     = each.value.virtual-network
  trusted-subnet-name = each.value.trusted-subnet-name
  mgmt-subnet-name    = each.value.mgmt-subnet-name
  # trusted-internal-loadbalancer           =   each.value.trusted-internal-loadbalancer
  trusted-internal-loadbalancer                           = each.value.trusted-internal-loadbalancer
  trusted-internal-loadbalancer-backend-address-pool-name = each.value.trusted-internal-loadbalancer-backend-address-pool-name
  firewall-vm                                             = each.value.firewall-vm
  # credential-keyvault-name                =   each.value.credential-keyvault-name
  # credential-keyvault-resource-group-name =   each.value.credential-keyvault-resource-group-name
  keyvault                    = each.value.keyvault
  admin-username              = each.value.admin-username
  admin-password              = try(each.value.admin-password, null)
  diagnostics-storage-account = each.value.diagnostics-storage-account
  backup_policy               = each.value.backup_policy
  virtual_networks            = module.Landscape-Virtual-Networks
  loadbalancers               = module.Landscape-Consolidated-Loadbalancers
  keyvaults                   = module.Landscape-Key-Vaults
  resource_groups             = module.Landscape-Resource-Groups
  backup_policies             = module.Landscape-Backup-Policy-VMs
}