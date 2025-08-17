# Instance identification
variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}


variable "tags" {
  description = "Additional tags to apply"
  type        = map(string)
  default     = {}
}

# Computation
variable "ami_id" {
  description = "AMI ID to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "user_data" {
  description = "User data to provide when launching the instance"
  type        = string
  default     = ""
}


# Security
variable "key_name" {
  description = "Key pair name to attach to the instance"
  type        = string
  default     = ""
}

variable "iam_instance_profile" {
  description = "Name of IAM instance profile to attach"
  type        = string
  default     = ""
}

# Network
variable "subnet_id" {
  description = "Subnet ID to launch the instance in"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate"
  type        = list(string)
  default     = []
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP"
  type        = bool
  default     = true
}


# Storage
variable "root_volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 8
}

variable "root_volume_type" {
  description = "Type of the root EBS volume"
  type        = string
  default     = "gp3"
}

variable "ebs_optimized" {
  description = "Whether the instance is EBS-optimized"
  type        = bool
  default     = false
}

# Others
variable "enable_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = false
}