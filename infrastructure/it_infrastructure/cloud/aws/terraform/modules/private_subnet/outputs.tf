output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = values(aws_subnet.private)[*].id
}

output "nat_gateway_ids" {
  description = "IDs of NAT Gateways (if any)"
  value       = try(aws_nat_gateway.this[*].id, [])
}

output "private_route_table_id" {
  description = "Private route table ID"
  value       = aws_route_table.private.id
}