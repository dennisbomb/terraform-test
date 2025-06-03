terraform {
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = ">= 3.30.0"
    }
  }
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = var.datadog_site
}

resource "datadog_monitor" "cpu_high" {
  name = "🚨 TLM - High CPU Usage per Host - PoC"
  type = "query alert"

  query = "avg(last_5m):avg:system.cpu.user{*} by {host} > 90"

  message = <<EOT
🔥 Critical: CPU usage > 90% on {{host.name}}
@slack-yourchannel
EOT

  escalation_message = "🚨 {{host.name}} remains over threshold — take action"

  monitor_thresholds {
    critical = 85 # was 90
  }

  notify_no_data      = true
  no_data_timeframe   = 10
  require_full_window = true
  new_group_delay     = 300
  include_tags        = true
  tags                = [
    "env:test",
    "team:Observability and Monitoring Platform"
  ]
}
