# variable "resource_group_name" {
#   type = string
#   description = "(Required) The name of the resource group in which to create the subnet. Changing this forces a new resource to be created."
# }

variable "resource_group" {
  type = object({
    name = optional(string) # Name of the resource group
    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"
  })
  description = "(Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup."
}

variable "resource_groups" {
  type = map(object({
    id       = optional(string)
    location = optional(string)
    tags     = optional(map(string))
    name     = optional(string)
  }))
  description = <<EOF
   (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"
    id       = # ID of the resource group
    location = # Location of the resource group
    tags     = # List of Azure tags applied to resource group
    name     = # Name of the resource group
  EOF
  default     = {}
}

variable "virtual_network_name" {
  type        = string
  description = "(Required) (Required) The name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created."
}
variable "name" {
  type        = string
  description = "(Required) The name of the subnet. Changing this forces a new resource to be created."
}

variable "address_prefixes" {
  type        = list(string)
  description = "(Required) The address prefixes to use for the subnet. If left null, entire address space of virtual network is used."
}

variable "service_endpoints" {
  type        = list(string)
  description = <<EOL
  (Optional) The list of Service endpoints to associate with the subnet. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, 
  Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, 
  Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage and Microsoft.Web.
  EOL
  default     = []
}

variable "service_endpoint_policy_ids" {
  type        = list(string)
  description = "(Optional) The list of IDs of Service Endpoint Policies to associate with the subnet."
  default     = null
}

variable "enforce_private_link_endpoint_network_policies" {
  type        = bool
  description = <<HELP
  (Optional) Enable or Disable network policies for the private link service on the subnet. Default valule is false. Conflicts with enforce_private_link_endpoint_network_policies.
  Network policies, like network security groups (NSG), are not supported for Private Link Endpoints or Private Link Services. 
  In order to deploy a Private Link Endpoint on a given subnet, you must set the enforce_private_link_endpoint_network_policies attribute to true. 
  This setting is only applicable for the Private Link Endpoint, for all other resources in the subnet access is controlled based via the Network Security Group which can be configured using the azurerm_subnet_network_security_group_association resource.
  HELP
  default     = false
}

variable "enforce_private_link_service_network_policies" {
  type        = bool
  description = <<HELP
  Optional) Enable or Disable network policies for the private link service on the subnet. Setting this to true will Disable the policy and setting this to false will Enable the policy. Default valule is false. Conflicts with enforce_private_link_endpoint_network_policies.
  In order to deploy a Private Link Service on a given subnet, you must set the enforce_private_link_service_network_policies attribute to true. 
  This setting is only applicable for the Private Link Service, for all other resources in the subnet access is controlled based on the Network Security Group which can be configured using the azurerm_subnet_network_security_group_association resource.
  HELP
  default     = false
}

variable "delegation" {
  type = object({
    name = optional(string) # A name for this delegation.
    service_delegation = object({
      name   = string                 # A value from the list at :https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#name
      action = optional(list(string)) # A list value from the list at :https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#actions
    })
  })
  default = null
}




