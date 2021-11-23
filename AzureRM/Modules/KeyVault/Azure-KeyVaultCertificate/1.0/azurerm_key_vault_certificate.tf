resource "azurerm_key_vault_certificate" "this" {
  name         = var.name
  key_vault_id = local.key_vault_id

  dynamic "certificate" {
    for_each = var.certificate == null || var.certificate == {} ? [] : [1]
    content {
      contents = var.certificate.contents
      password = var.certificate.password
    }
  }

  certificate_policy {
    issuer_parameters {
      name = var.certificate_policy.issuer_parameters.name
    }
    key_properties {
      curve      = var.certificate_policy.key_properties.curve
      exportable = var.certificate_policy.key_properties.exportable
      key_size   = var.certificate_policy.key_properties.key_size
      key_type   = var.certificate_policy.key_properties.key_type
      reuse_key  = var.certificate_policy.key_properties.reuse_key
    }
    dynamic "lifetime_action" {
      for_each = var.certificate_policy.lifetime_action == null || var.certificate_policy.lifetime_action == {} ? [] : [1]
      content {
        action {
          action_type = var.certificate_policy.lifetime_action.action.action_type
        }
        trigger {
          days_before_expiry  = var.certificate_policy.lifetime_action.trigger.days_before_expiry
          lifetime_percentage = var.certificate_policy.lifetime_action.trigger.lifetime_percentage
        }
      }
    }
    secret_properties {
      content_type = var.certificate_policy.secret_properties.content_type
    }
    x509_certificate_properties {
      extended_key_usage = var.certificate_policy.x509_certificate_properties.extended_key_usage
      key_usage          = var.certificate_policy.x509_certificate_properties.key_usage
      subject            = var.certificate_policy.x509_certificate_properties.subject
      dynamic "subject_alternative_names" {
        for_each = var.certificate_policy.x509_certificate_properties.subject_alternative_names == null || var.certificate_policy.x509_certificate_properties.subject_alternative_names == {} ? [] : [1]
        content {
          dns_names = var.certificate_policy.x509_certificate_properties.subject_alternative_names.dns_names
          emails    = var.certificate_policy.x509_certificate_properties.subject_alternative_names.emails
          upns      = var.certificate_policy.x509_certificate_properties.subject_alternative_names.upns
        }
      }
      validity_in_months = var.certificate_policy.x509_certificate_properties.validity_in_months
    }
  }

  tags = var.tags
}