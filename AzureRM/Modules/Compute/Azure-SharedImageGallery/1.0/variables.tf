variable "name" {
  type        = string
  description = <<EOT
  (Required) Specifies the name of the Shared Image Gallery. 
  Changing this forces a new resource to be created.
  EOT
}

variable "location" {
  type        = string
  description = <<EOT
  (Required) Specifies the supported Azure location where the resource exists. 
  Changing this forces a new resource to be created.
  EOT
  default     = null
}

# variable "resource_group_name" {
#   type = string
#   description = <<EOT
#    (Required) The name of the resource group in which to create the Shared Image Gallery. 
#    Changing this forces a new resource to be created.
#    EOT
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

variable "description" {
  type        = string
  description = <<EOT
    (Required) Specifies the supported Azure location where the resource exists. 
    Changing this forces a new resource to be created.
  EOT
  sensitive   = true
}

variable "tags" {
  type        = map(string)
  description = <<EOT
    (Optional) A mapping of tags which should be assigned to the Shared Image Gallery.
  EOT
  default     = {}
}

variable "inherit_tags" {
  type        = bool
  default     = false
  description = "If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'."
}



