
# Note slack integrations for the service to the relevant channels must be done manually in pagerduty and slack
resource "pagerduty_service" "core_alerts" {
  name                    = "Modernisation Platform Core Alerts"
  description             = "Modernisation Platform Core Infrastructure Alerts"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = null
  escalation_policy       = pagerduty_escalation_policy.default.id
  alert_creation          = "create_alerts_and_incidents"
}

resource "pagerduty_service_integration" "cloudwatch" {
  name    = data.pagerduty_vendor.cloudwatch.name
  service = pagerduty_service.core_alerts.id
  vendor  = data.pagerduty_vendor.cloudwatch.id
}

resource "pagerduty_service_event_rule" "mfa-console-access" {
  service  = pagerduty_service.core_alerts.id
  position = 0
  disabled = "false"

  conditions {
    operator = "and"
    subconditions {
      operator = "contains"
      parameter {
        value = "sign-in-without-mfa"
        path  = "summary"
      }
    }
  }

  actions {
    severity {
      value = "info"
    }
    annotate {
      value = "Suppressed as triggered by SSO sign on"
    }

    suppress {
      value = true
    }
  }
}
