# FREE TIER Configuration Variables

variable "region" {
  description = "AWS Region for resources"
  type        = string
  default     = "ap-southeast-2"  # Sydney - conforme sua conta AWS
}

variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
  default     = "iac-serverless"
  
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

# Optional: Environment variable for resource tagging
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "free-tier"
}

# Optional: Enable/disable detailed monitoring (can incur costs)
variable "enable_detailed_monitoring" {
  description = "Enable detailed monitoring (may incur additional costs)"
  type        = bool
  default     = false  # FREE TIER: disabled by default
}
