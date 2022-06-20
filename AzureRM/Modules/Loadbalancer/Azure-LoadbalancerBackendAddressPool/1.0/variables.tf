variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Backend Address Pool."
}

variable "loadbalancer" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    key                 = optional(string)
  })
  description = "(Required) The ID of the Load Balancer in which to create the Backend Address Pool."
}

variable "loadbalancers" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}

