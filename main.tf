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


resource "datadog_monitor" "eth39_inbound_high_capacity" {
  name = "TLM: NET: High Inbound Traffic (HC Octets Rate) on ethernet39 - 60hudson-05-leaf-01"

  type  = "metric alert"

  query = <<EOT
avg(last_5m):avg:snmp.ifHCInOctets.rate{interface:ethernet39,snmp_host:60hudson-05-leaf-01.mskcc.org} by {snmp_host,interface} > 900000000
EOT

  message = <<EOM
🚨 High-rate inbound SNMP traffic detected on ethernet39 ({{interface.name}})  
Switch: {{snmp_host.name}}  
Threshold: > 900 Mbps (measured using `ifHCInOctets.rate`) over 5 minutes  

@slack-network-team
EOM

  monitor_thresholds {
    critical = 900000000
  }

  notify_no_data      = true
  no_data_timeframe   = 10
  require_full_window = true
  include_tags        = true

  tags = [
    "interface:ethernet39",
    "device_type:switch",
    "location:60hudson",
    "source:snmp"
  ]
}
 
