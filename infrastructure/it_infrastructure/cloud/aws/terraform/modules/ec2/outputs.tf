# Instance identity
output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "instance_arn" {
  description = "The ARN of the EC2 instance"
  value       = aws_instance.this.arn
}

# Network
output "public_ip" {
  description = "The public IP assigned to the instance"
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "The private IP assigned to the instance"
  value       = aws_instance.this.private_ip
}

# 
output "availability_zone" {
  description = "The availability zone in which the instance is running"
  value       = aws_instance.this.availability_zone
}