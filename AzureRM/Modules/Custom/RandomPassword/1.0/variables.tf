variable "length" {
  type        = number
  description = "(Required)The length of the string desired."
}

variable "keepers" {
  type        = map(string)
  description = "(Optional)Arbitrary map of values that, when changed, will trigger recreation of resource. Use this to re-generate the password string."
  default     = null
}

variable "lower" {
  type        = bool
  description = "(Optional)Include lowercase alphabet characters in the result."
  default     = true
}

variable "min_lower" {
  type        = number
  description = "(Optional)Minimum number of lowercase alphabet characters in the result."
  default     = 2
}

variable "min_upper" {
  type        = number
  description = "(Optional)Minimum number of numeric characters in the result."
  default     = 2
}

variable "min_special" {
  type        = number
  description = "(Optional)Minimum number of special characters in the result."
  default     = 2
}

variable "min_upper" {
  type        = number
  description = "(Optional)Minimum number of uppercase alphabet characters in the result."
  default     = 2
}

variable "number" {
  type        = bool
  description = "(Optional)Include numeric characters in the result."
  default     = true
}

variable "override_special" {
  type        = string
  description = <<HELP
    (Optional)Supply your own list of special characters to use for string generation. 
    This overrides the default character list in the special argument.
    The special argument must still be set to true for any overwritten characters to be used in generation.
    HELP
  default     = null
}

variable "special" {
  type        = bool
  description = "(Optional) Include special characters in the result. These are !@#$%&*()-_=+[]{}<>:?"
  default     = false
}

variable "upper" {
  type        = bool
  description = "(Optional)Include uppercase alphabet characters in the result."
  default     = true
}


