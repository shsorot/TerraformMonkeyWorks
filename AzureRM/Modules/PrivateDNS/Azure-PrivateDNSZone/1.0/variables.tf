variable "name" {
  type        = string
  description = "(Required) The name of the Private DNS Zone. Must be a valid domain name."
}

# variable "resource_group_name" {
#     type = string 
#     description = "(Required) Specifies the resource group where the resource exists. Changing this forces a new resource to be created."
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

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
}

variable "inherit_tags" {
  type    = bool
  default = false
}

variable "soa_record" {
  type = object({
    email        = string                #   (Required) The email contact for the SOA record.
    expire_time  = optional(string)      #   (Optional) The expire time for the SOA record. Defaults to 2419200.
    minimum_ttl  = optional(string)      #   (Optional) The minimum Time To Live for the SOA record. By convention, it is used to determine the negative caching duration. Defaults to 10
    refresh_time = optional(string)      #   (Optional) The refresh time for the SOA record. Defaults to 3600.
    retry_time   = optional(string)      #   (Optional) The retry time for the SOA record. Defaults to 300.
    ttl          = optional(string)      #   (Optional) The Time To Live of the SOA Record in seconds. Defaults to 3600.
    tags         = optional(map(string)) #   (Optional) A mapping of tags to assign to the Record Set.
  })
}

