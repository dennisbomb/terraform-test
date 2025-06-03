terraform {
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "3.27.0"
    }
  }
}


provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = var.datadog_site
}

resource "datadog_monitor" "cpu_high" {
  name = "High CPU Alert"
  type = "query alert"
  query = "avg(last_5m):avg:system.cpu.user{*} > 90"

  message = "🚨 CPU usage is high on {{host.name}}"
  tags    = ["env:test"]

  thresholds {
    critical = 90
  }

  notify_no_data    = true
  no_data_timeframe = 10
}

