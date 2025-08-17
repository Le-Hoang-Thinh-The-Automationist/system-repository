# VPC Identity
variable "name" {
  description = "Base name for VPC"
  type        = string
}

variable "cidr_block" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tags" {
  description = "Additional tags for VPC and related resources"
  type        = map(string)
  default     = {}
}

# CloudWatch integration
variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = false
}

variable "flow_logs_retention_in_days" {
  description = "Flow Logs retention in days"
  type        = number
  default     = 14
}
