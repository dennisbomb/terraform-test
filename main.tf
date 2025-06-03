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
    critical = 90
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

resource "datadog_monitor" "switch_eth39_traffic" {
  name = "TLM: NET: High Traffic on eth39 (Inbound/Outbound) - 60hudson-05-leaf-01"

  type  = "metric alert"
  query = <<EOT
avg(last_5m):(
  avg:network.interface.in.bytes{host:60hudson-05-leaf-01.mskcc.org,interface:eth39} +
  avg:network.interface.out.bytes{host:60hudson-05-leaf-01.mskcc.org,interface:eth39}
) > 200000000
EOT

  message = <<EOM
🚨 High combined traffic on eth39 (in+out) on {{host.name}}  
Threshold: > 200 MB over 5 minutes

@slack-network-team
EOM

  escalation_message = "eth39 inbound + outbound traffic exceeds safe limit. Please investigate switch: 60hudson-05-leaf-01."

  monitor_thresholds {
    critical = 200000000
  }

  notify_no_data      = true
  no_data_timeframe   = 10
  require_full_window = true
  include_tags        = true
  tags = [
    "device:switch",
    "interface:eth39",
    "location:60hudson",
    "direction:inout"
  ]
}

