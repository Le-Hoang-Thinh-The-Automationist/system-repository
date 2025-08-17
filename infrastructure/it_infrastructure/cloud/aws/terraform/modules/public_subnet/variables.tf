variable "name" {
  description = "Base name for public subnets"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "azs" {
  description = "List of AZs for public subnets"
  type        = list(string)
}

variable "cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}