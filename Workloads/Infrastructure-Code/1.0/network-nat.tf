variable "NATGateways" {
  default = {}
}

module "Landscape-NAT-Gateways" {
  source                  = "../../../AzureRM/Modules/Network/Azure-NATGateway/1.0"
  for_each                = var.NATGateways
  name                    = each.value.name == null ? each.key : each.value.name

  resource_group          = each.value.resource_group
  location                = try(each.value.location, null)
  idle_timeout_in_minutes = try(each.value.idle_timeout_in_minutes, 4)
  sku_name                = try(each.value.sku_name, "Standard")
  tags                    = try(each.value.tags, {})
  inherit_tags            = try(each.value.inherit_tags, false)
  zones                   = try(each.value.zones, null)
  resource_groups         = module.Landscape-Resource-Groups
}

output "NATGateways" {
  value = module.Landscape-NAT-Gateways
}


variable "NATGatewayPublicIPAssociations" {
  default = {}
}

module "Landscape-NAT-Gateway-Public-IP-Associations" {
  source              = "../../../AzureRM/Modules/Network/Azure-NATGatewayPublicIPAssociation/1.0"
  for_each            = var.NATGatewayPublicIPAssociations
  nat_gateway         = each.value.nat_gateway
  public_ip_address   = each.value.public_ip_address
  nat_gateways        = module.Landscape-NAT-Gateways
  public_ip_addresses = module.Landscape-Public-IP-Addresses
}

output "NATGatewayPublicIPAssociations" {
  value = module.Landscape-NAT-Gateway-Public-IP-Associations
}


variable "NATGatewayPublicIPPrefixAssociations" {
  default = {}
}

module "Landscape-NAT-Gateway-Public-IP-Prefix-Associations" {
  source             = "../../../AzureRM/Modules/Network/Azure-NATGatewayPublicIPPrefixAssociation/1.0"
  for_each           = var.NATGatewayPublicIPPrefixAssociations
  nat_gateway        = each.value.nat_gateway
  public_ip_prefix   = each.value.public_ip_prefix
  nat_gateways       = module.Landscape-NAT-Gateways
  public_ip_prefixes = module.Landscape-Public-IP-Prefixes
}

output "NATGatewayPublicIPPrefixAssociations" {
  value = module.Landscape-NAT-Gateway-Public-IP-Prefix-Associations
}


variable "SubnetNATGatewayAssociations" {
  default = {}
}

module "Landscape-Subnet-NAT-Gateway-Associations" {
  source           = "../../../AzureRM/Modules/Network/Azure-SubnetNATGatewayAssociation/1.0"
  for_each         = var.SubnetNATGatewayAssociations
  nat_gateway      = each.value.subnet
  subnet           = each.value.subnet
  nat_gateways     = module.Landscape-NAT-Gateways
  virtual_networks = module.Landscape-Virtual-Networks
}

output "SubnetNATGatewayAssociations" {
  value = module.Landscape-Subnet-NAT-Gateway-Associations
}

