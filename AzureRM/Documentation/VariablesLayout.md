# Module variable layout.

To explain how variables are defined in the variables.tf , we will use the example of module Azure-AvailabilitySet->1.0
(AzureRM->Modules->Compute->Azure-AvailabilitySet->1.0->variables.tf)

The code segment is as below

```
variable "location" {
  description = "Location to provision the Availability Set. If null, it will be fetched from Resource Group"
  type        = string
  default = null
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

variable "name" {
  description = "Name of the availability set"
  type        = string
}

variable "platform_fault_domain_count" {
  description = "Number of Fault Domain"
  type        = number
  default     = 2
}

variable "platform_update_domain_count" {
  description = "Number of update domains"
  type        = number
  default     = 5
}

variable "proximity_placement_group" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    key                 = optional(string)
  })
  description = "(Optional) The ID of the Proximity Placement Group to which this Virtual Machine should be assigned. Changing this forces a new resource to be created."
  default     = null
}

variable "proximity_placement_groups" {
  type = map(object({
    id = optional(string)
  }))
  default     = {}
  description = "(Optional) Output of module Azure-ProximityPlacementGroup for lookup of PPG ID."
}

variable "managed" {
  type        = bool
  description = "(Optional) Specifies whether the availability set is managed or not. Possible values are true (to specify aligned) or false (to specify classic). Default is true."
  default     = true
}

variable "tags" {
  type    = map(string)
  description = " (Optional) A mapping of tags to assign to the resource."
  default = {}
}

variable "inherit_tags" {
  type        = bool
  default     = false
  description = "If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'."
}
```

Lets take a look at the variable block

```
variable "proximity_placement_group" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    key                 = optional(string)
  })
  description = "(Optional) The ID of the Proximity Placement Group to which this Virtual Machine should be assigned. Changing this forces a new resource to be created."
  default     = null
}

variable "proximity_placement_groups" {
  type = map(object({
    id = optional(string)
  }))
  default     = {}
  description = "(Optional) Output of module Azure-ProximityPlacementGroup for lookup of PPG ID."
}

```

The 'proximity_placement_group' variable is used to calculate value to the property 'proximity_placement_group_id'.
If you know the ID, specify the same using  'proximity_placement_group= { id = "string"}'
Alternatively, if you know the the name of the resource and resource group(optional), you can specify the variable as below
'proximity_placement_group = { name = "PPG1", resource_group_name = "RG1"}'

*Note: Sub property Resource group is optional, if null the code will attempt to use the parent resource group where the resource block for availability set is being created. This behavior is consistent for all other modules*

If you are using the module Azure-ProximityPlacemenGroup to create the PPG and have the output of the module in the format "key"={output of module} in JSON format or map(object) in HCL convention, you can pass the output to the varibale 'proximity_placement_groups'. To refer a single object, use the Key and pass the same using notation   'proximity_placement_group = {key = "keyname"}'

*Note:If you are not using the 'proximity_placement_groups', you must always pass an empty object as parameter.*

