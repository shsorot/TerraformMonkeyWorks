variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Dedicated Host Group. Changing this forces a new resource to be created."
}

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

variable "location" {
  type        = string
  description = "(Required) The Azure location where the Dedicated Host Group exists. Changing this forces a new resource to be created."
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}

variable "inherit_tags" {
  type        = bool
  default     = false
  description = "If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'."
}

# Note that starting with provider 3.7.0, this is changed to "zones"
variable "zone" {
  type        = number
  description = "(Optional) A list of Availability Zones in which the Dedicated Host Group should be located. Changing this forces a new resource to be created."
  default     = null
}

variable "platform_fault_domain_count" {
  type        = number
  description = "(Required) The number of fault domains that the Dedicated Host Group spans. Changing this forces a new resource to be created."
}

variable "automatic_placement_enabled" {
  type        = bool
  description = "(Optional) Would virtual machines or virtual machine scale sets be placed automatically on this Dedicated Host Group? Defaults to false. Changing this forces a new resource to be created."
  default     = false
}

