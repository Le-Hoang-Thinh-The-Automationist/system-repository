resource "aws_subnet" "private" {
  for_each             = zipmap(var.azs, var.cidrs)
  vpc_id               = var.vpc_id
  cidr_block           = each.value
  availability_zone    = each.key
  map_public_ip_on_launch = false

  tags = merge(
    { Name = "${var.name}-${each.key}" },
    var.tags
  )
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  tags = merge(
    { Name = "${var.name}-rt-private" },
    var.tags
  )
}

resource "aws_route_table_association" "private_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

# NAT Gateway integration
resource "aws_eip" "nat" {
  count = var.enable_nat ? (var.single_nat ? 1 : length(var.azs)) : 0
  vpc   = true

  tags = merge(
    { Name = "${var.name}-eip-${count.index}" },
    var.tags
  )
}

resource "aws_nat_gateway" "this" {
  count         = length(aws_eip.nat)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = var.single_nat ? var.public_subnet_ids[0] : var.public_subnet_ids[count.index]

  tags = merge(
    { Name = "${var.name}-nat-${count.index}" },
    var.tags
  )
}

resource "aws_route" "to_nat" {
  count                   = var.enable_nat ? length(aws_nat_gateway.this) : 0
  route_table_id          = aws_route_table.private.id
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id          = aws_nat_gateway.this[count.index].id
}