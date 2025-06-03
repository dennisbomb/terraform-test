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

  # No comparison in the query – thresholds handle it
  query = "avg(last_5m):avg:system.cpu.user{*} by {host}"

  message = <<EOT
⚠️ CPU usage warning at 70%, critical at 90%
Host: {{host.name}}

@slack-yourchannel
EOT

  escalation_message = "🚨 {{host.name}} is still over 90% CPU – action required!"

  monitor_thresholds {
    warning  = 70
    critical = 90
  }

  notify_no_data      = true
  no_data_timeframe   = 10
  require_full_window = true
  new_group_delay     = 300  # replaces deprecated new_host_delay
  include_tags        = true
  tags                = [
    "env:test",
    "team:ops"
  ]
}
