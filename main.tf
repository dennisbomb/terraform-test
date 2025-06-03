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

resource "datadog_dashboard" "example" {
  title        = "My Terraform Dashboard"
  description  = "Created via GitHub Actions + Terraform"
  layout_type  = "ordered"
  is_read_only = false
  notify_list  = []

  widget {
    definition {
      timeseries_definition {
        title = "System CPU (User)"
        show_legend = true
        legend_size = "0"
        time = {}
        type = "line"
        requests {
          q = "avg:system.cpu.user{*}"
          display_type = "line"
          style {
            palette = "dog_classic"
            line_type = "solid"
            line_width = "normal"
          }
        }
      }
    }

    layout {
      x      = 0
      y      = 0
      width  = 47
      height = 15
    }
  }
}
#ssss
