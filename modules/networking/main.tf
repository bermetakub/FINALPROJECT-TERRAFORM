data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpcCIDR
  tags                 = var.tag
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet" {
  for_each                = { for idx, cidr in var.public_cidrs : cidr => { cidr = cidr, az = element(data.aws_availability_zones.available.names, idx) } }
  availability_zone       = each.value.az
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${var.name}-public-subnet-${each.key}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "public-rt" {
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public-rt-associate" {
  for_each       = toset(var.public_cidrs)
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.public_subnet[each.key].id
}


resource "aws_subnet" "private_subnet" {
  for_each                = { for idx, cidr in var.private_cidrs : cidr => { cidr = cidr, az = element(data.aws_availability_zones.available.names, idx % length(data.aws_availability_zones.available.names)) } }
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false

  tags = {
    "Name" = "${var.name}-private-subnet-${each.key}"
  }
}

resource "aws_eip" "eip" {
  tags = {
    "Name" = "${var.name}-eip"
  }
}

resource "aws_nat_gateway" "NAT" {
  subnet_id     = aws_subnet.public_subnet[sort(keys(aws_subnet.public_subnet))[0]].id
  allocation_id = aws_eip.eip.id
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "private-route" {
  route_table_id         = aws_route_table.private-rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.NAT.id
}

resource "aws_route_table_association" "private-rt-associate" {
  for_each       = toset(var.private_cidrs)
  route_table_id = aws_route_table.private-rt.id
  subnet_id      = aws_subnet.private_subnet[each.key].id
}