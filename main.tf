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
  name = "🚨 High CPU Usage per Host"
  type = "query alert"

  query = "avg(last_5m):avg:system.cpu.user{*} by {host} > 70"

  message = <<EOT
⚠️ Warning if CPU usage > 70%
🔥 Critical if CPU usage > 90%
Host: {{host.name}}

@slack-yourchannel
EOT

  escalation_message = "🚨 {{host.name}} still critical — immediate action required!"

  monitor_thresholds {
    warning  = 70
    critical = 90
  }

  notify_no_data     = true
  no_data_timeframe  = 10
  require_full_window = true
  new_host_delay      = 300
  include_tags        = true
  tags                = [
    "env:test",
    "team:ops"
  ]
}
