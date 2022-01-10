resource "random_password" "this" {
  length           = var.length
  keepers          = var.keepers
  lower            = var.lower
  upper            = var.upper
  min_upper        = var.min_upper
  min_lower        = var.min_lower
  min_numeric      = var.min_numeric
  min_special      = var.min_special
  number           = var.number
  override_special = var.override_special
  special          = var.special
}