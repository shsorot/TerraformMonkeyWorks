resource_group_name  = "network-rg"
virtual_network_name = "test-vnet"
address_prefixes     = ["10.0.1.0/24"]
name                 = "app"
#service_endpoints       =   ["Microsoft.KeyVault"]
delegation = {
  name = "NetApp_Delegation"
  service_delegation = {
    name = "Microsoft.Netapp/volumes"
  }
}