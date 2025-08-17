# Identity
variable "name" {
  description = "Base name for private subnets"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "azs" {
  description = "List of AZs for private subnets"
  type        = list(string)
}

variable "cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

# NAT Gateway integration
variable "enable_nat" {
  description = "Whether to create NAT Gateways"
  type        = bool
  default     = false
}

variable "single_nat" {
  description = "If true, use one NAT in the first public subnet"
  type        = bool
  default     = true
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for NAT placement"
  type        = list(string)
  default     = []
}
