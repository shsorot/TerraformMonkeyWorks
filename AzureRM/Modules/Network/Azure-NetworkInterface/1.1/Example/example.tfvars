resource_group_name = "network-rg"
location            = "North Europe"
virtual_network = {
  name                = "test-vnet"
  resource_group_name = "network-rg"
}
name                          = "test-nic0"
tags                          = {}
inherit_tags                  = true
dns_servers                   = []
enable_accelerated_networking = false
ip_configuration = [
  {
    name = "ipconfig1"
    subnet = {
      name = "default"
    }
    private_ip_address         = null
    private_ip_address_version = "IPv4"
    primary                    = true
    backend_address_pool = {
      load_balancer_name  = "test-lb"
      resource_group_name = "network-rg"
      name                = "defaultpool"
    }
    # public_ip_address   =   {
    #     name                =   "test-pip"
    #     resource_group_name =   "network-rg"
    # }

  }
]
application_security_group = {
  name                = "test-asg"
  resource_group_name = "network-rg"
}