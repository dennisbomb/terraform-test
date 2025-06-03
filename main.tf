terraform {
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.30"
    }
  }
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = var.datadog_site
}

resource "datadog_monitor" "cpu_high" {
  name               = "High CPU Usage"
  type               = "metric alert"
  query              = "avg(last_5m):avg:system.cpu.user{*} > 90"
  message            = "🚨 CPU usage is too high on {{host.name}}"
  escalation_message = "⚠️ Please investigate high CPU on {{host.name}}"

  threshold_critical = 90
  notify_no_data     = true
  no_data_timeframe  = 10
  tags               = ["env:test", "team:ops"]
}
