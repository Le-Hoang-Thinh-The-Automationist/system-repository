output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "The ARN of the created VPC"
  value       = aws_vpc.this.arn
}