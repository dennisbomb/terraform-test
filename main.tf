# main.tf — good!
provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  site    = var.datadog_site
}

# variables.tf — this is where they should be defined
variable "datadog_api_key" {
  description = "Datadog API key"
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Datadog APP key"
  type        = string
  sensitive   = true
}

variable "datadog_site" {
  description = "Datadog site URL"
  type        = string
  default     = "datadoghq.com"
}
# Test GitHub Actions trigger
