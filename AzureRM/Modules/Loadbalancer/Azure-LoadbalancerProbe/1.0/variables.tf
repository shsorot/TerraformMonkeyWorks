variable "name" {
  type        = string
  description = "(Required) Specifies the name of the probe."
}


variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group where the load balancer is located. If Null, the property resource_group_name in object 'loadbalancer' must be specified"
  default     = null
}

variable "loadbalancer" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
  description = "(Required) The ID of the Load Balancer in which to create the Backend Address Pool."
}

variable "protocol" {
  type        = string
  description = "(Optional) Specifies the protocol of the end point. Possible values are Http, Https or Tcp. If Tcp is specified, a received ACK is required for the probe to be successful. If Http is specified, a 200 OK response from the specified URI is required for the probe to be successful."
  default     = null
}


variable "port" {
  type        = number
  description = "(Required) Port on which the Probe queries the backend endpoint. Possible values range from 1 to 65535, inclusive."
}

variable "request_path" {
  type        = string
  description = "(Optional) The URI used for requesting health status from the backend endpoint. Required if protocol is set to Http or Https. Otherwise, it is not allowed."
  default     = null
}

variable "interval_in_seconds" {
  type        = number
  description = "(Optional) The URI used for requesting health status from the backend endpoint. Required if protocol is set to Http or Https. Otherwise, it is not allowed."
  default     = 15
}

variable "number_of_probes" {
  type        = number
  description = "(Optional) The number of failed probe attempts after which the backend endpoint is removed from rotation. The default value is 2. NumberOfProbes multiplied by intervalInSeconds value must be greater or equal to 10.Endpoints are returned to rotation when at least one probe is successful."
  default     = 2
}

variable "loadbalancers" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}

