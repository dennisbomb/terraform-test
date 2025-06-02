terraform {
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.30.0"
    }
  }
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  site    = var.datadog_site
}

variable "datadog_api_key" {}
variable "datadog_app_key" {}
variable "datadog_site" {}

resource "datadog_dashboard" "example_dashboard" {
  title       = "TLM PoC Dashboard"
  description = "My test dashboard created via Terraform and GitHub Actions"
  layout_type = "ordered"
  is_read_only = false

  widget {
    group_definition {
      title = "Sample Group"
      layout_type = "ordered"
      widget {
        timeseries_definition {
          title = "System Load (avg. 1m)"
          show_legend = true
          legend_size = "0"
          type = "line"
          requests {
            q = "avg:system.load.1{*}"
            display_type = "line"
            style {
              palette = "dog_classic"
              line_type = "solid"
              line_width = "normal"
            }
          }
        }
      }
    }
  }
}

