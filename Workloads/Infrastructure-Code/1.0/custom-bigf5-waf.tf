variable "CustomBigF5owafAppliances" {
  default = {}
}


module "Landscale-BigF5-waf" {
  source   = "../../../AzureRM/Modules/Custom/BigIPF5-WAF/1.0"
  for_each = var.CustomBigF5owafAppliances
  # virtual-machine-resource-group-name     =   each.value.virtual-machine-resource-group-name
  # virtual-network-name                    =   each.value.virtual-network-name
  # virtual-network-resource-group-name     =   each.value.virtual-network-resource-group-name
  resource-group                                            = each.value.resource-group
  virtual-network                                           = each.value.virtual-network
  trusted-subnet-name                                       = each.value.trusted-subnet-name
  untrusted-subnet-name                                     = each.value.untrusted-subnet-name
  mgmt-subnet-name                                          = each.value.mgmt-subnet-name
  untrusted-external-loadbalancer                           = each.value.untrusted-external-loadbalancer
  untrusted-external-loadbalancer-backend-address-pool-name = each.value.untrusted-external-loadbalancer-backend-address-pool-name
  untrusted-internal-loadbalancer                           = each.value.untrusted-internal-loadbalancer
  untrusted-internal-loadbalancer-backend-address-pool-name = each.value.untrusted-internal-loadbalancer-backend-address-pool-name
  waf-vm                                                    = each.value.waf-vm
  # credential-keyvault-name                =   each.value.credential-keyvault-name
  # credential-keyvault-resource-group-name =   each.value.credential-keyvault-resource-group-name
  keyvault                    = each.value.keyvault
  admin-username              = each.value.admin-username
  admin-password              = try(each.value.admin-password, null)
  diagnostics-storage-account = each.value.diagnostics-storage-account
  virtual_networks            = module.Landscape-Virtual-Networks
  loadbalancers               = module.Landscape-Consolidated-Loadbalancers
  keyvaults                   = module.Landscape-Key-Vaults
  resource_groups             = module.Landscape-Resource-Groups
}


