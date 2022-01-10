variable "BastionHosts" {
  default = {}
}


module "Landscape-Bastion-Hosts" {
  source         = "../../../AzureRM/Modules/Network/Azure-BastionHost/2.0"
  for_each       = var.BastionHosts
  name           = each.value.name == null ? each.key : each.value.name
  resource_group = each.value.resource_group
  location       = try(each.value.location, null)
  tags           = try(each.value.tags, local.tags)
  inherit_tags   = try(each.value.inherit_tags, false)

  ip_configuration_name = try(each.value.ip_configuration_name, "ip_configuration")

  subnet = each.value.subnet

  public_ip_address = each.value.public_ip_address
  resource_groups   = module.Landscape-Resource-Groups
}


output "BastionHosts" {
  value = module.Landscape-Bastion-Hosts
}