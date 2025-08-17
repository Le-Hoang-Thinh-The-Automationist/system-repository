resource "aws_subnet" "public" {
  for_each                = zipmap(var.azs, var.cidrs)
  vpc_id                  = var.vpc_id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = merge(
    { Name = "${var.name}-${each.key}" },
    var.tags
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = merge(
    { Name = "${var.name}-igw" },
    var.tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = merge(
    { Name = "${var.name}-rt-public" },
    var.tags
  )
}

resource "aws_route" "default_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}