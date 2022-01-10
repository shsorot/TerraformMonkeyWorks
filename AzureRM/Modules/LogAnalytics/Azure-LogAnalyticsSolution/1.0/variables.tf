variable "solution_name" {
  type        = string
  description = "(Required) Specifies the name of the solution to be deployed. See here for options.Changing this forces a new resource to be created."
}

# variable "resource_group_name" {
#   type = string
#   description = <<HELP
#   (Required) The name of the resource group in which the Log Analytics solution is created. 
#   Changing this forces a new resource to be created. 
#   Note: The solution and its related workspace can only exist in the same resource group.
#   HELP
# }

variable "resource_group" {
  type = object({
    name = optional(string)
    tag  = optional(string)
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
  description = "(Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Tags"
  default     = {}
}

variable "location" {
  type        = string
  description = " (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  default     = null
}

variable "workspace_resource" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
  description = " (Required) The full resource ID of the Log Analytics workspace with which the solution will be linked. Changing this forces a new resource to be created."
}

variable "log_analytics_workspaces" {
  type = map(object({
    id = optional(string)
  }))
}

variable "workspace_name" {
  type        = string
  description = " (Required) The full name of the Log Analytics workspace with which the solution will be linked. Changing this forces a new resource to be created."
}


variable "plan" {
  type = object({
    publisher      = string           #   (Required) The publisher of the solution. For example Microsoft. Changing this forces a new resource to be created.
    product        = string           #   (Required) The product name of the solution. For example OMSGallery/Containers. Changing this forces a new resource to be created.
    promotion_code = optional(string) #   (Optional) A promotion code to be used with the solution.
  })
}


variable "tags" {
  type    = map(string)
  default = {}
}

variable "inherit_tags" {
  type    = bool
  default = false
}

