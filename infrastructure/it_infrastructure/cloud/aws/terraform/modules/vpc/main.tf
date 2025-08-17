resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    { Name = var.name },
    var.tags
  )
}

# CloudWatch integration
resource "aws_flow_log" "this" {
  count           = var.enable_flow_logs ? 1 : 0
  vpc_id          = aws_vpc.this.id
  traffic_type    = "ALL"
  log_destination = aws_cloudwatch_log_group.vpc_flow[count.index].arn

  depends_on = [aws_cloudwatch_log_group.vpc_flow]
}

resource "aws_cloudwatch_log_group" "vpc_flow" {
  count             = var.enable_flow_logs ? 1 : 0
  name              = "/aws/vpc-flow/${var.name}"
  retention_in_days = var.flow_logs_retention_in_days
  tags              = var.tags
}