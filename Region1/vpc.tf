data "aws_availability_zones" "available" {
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
}

#resource "aws_subnet" "public" {
#  map_public_ip_on_launch = "true"
#  count                   = length(var.public_subnet)
#  cidr_block              = var.public_subnet[count.index]
#  vpc_id                  = aws_vpc.vpc.id
#  availability_zone       = data.aws_availability_zones.available.names[count.index]
#
#  tags = {
#    "Name" = "Public_subnet_${regex(".$", data.aws_availability_zones.available.names[count.index])}_${aws_vpc.vpc.id}"
#  }
#}
#
#resource "aws_subnet" "private" {
#  map_public_ip_on_launch = "true"
#  count                   = length(var.private_subnet)
#  cidr_block              = var.private_subnet[count.index]
#  vpc_id                  = aws_vpc.vpc.id
#  availability_zone       = data.aws_availability_zones.available.names[count.index]
#
#  tags = {
#    "Name" = "Private_subnet_${regex(".$", data.aws_availability_zones.available.names[count.index])}_${aws_vpc.vpc.id}"
#  }
#}
resource "aws_subnet" "public" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.vpc.id

  tags = {
    "Name" = "Private_subnet_${regex(".$", data.aws_availability_zones.available.names[count.index])}_${aws_vpc.vpc.id}"
  }
}

resource "aws_subnet" "private" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = var.private_subnets[count.index]
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.vpc.id

  tags = {
    "Name" = "Private_subnet_${regex(".$", data.aws_availability_zones.available.names[count.index])}_${aws_vpc.vpc.id}"
  }
}


#resource "aws_subnet" "private-us-west-1a" {
#  vpc_id            = aws_vpc.main.id
#  cidr_block        = "10.0.0.0/19"
#  availability_zone = "us-west-2a"
#
#  tags = {
#    "Name"                            = "private-us-west-2a"
#    "kubernetes.io/role/internal-elb" = "1"
#    "kubernetes.io/cluster/demo"      = "owned"
#  }
#}
#
#resource "aws_subnet" "private-us-west-2b" {
#  vpc_id            = aws_vpc.main.id
#  cidr_block        = "10.0.32.0/19"
#  availability_zone = "us-west-2b"
#
#  tags = {
#    "Name"                            = "private-us-west-2b"
#    "kubernetes.io/role/internal-elb" = "1"
#    "kubernetes.io/cluster/demo"      = "owned"
#  }
#}
#
#resource "aws_subnet" "public-us-west-1a" {
#  vpc_id                  = aws_vpc.main.id
#  cidr_block              = "10.0.64.0/19"
#  availability_zone       = "us-west-2a"
#  map_public_ip_on_launch = true
#
#  tags = {
#    "Name"                       = "public-us-west-2a"
#    "kubernetes.io/role/elb"     = "1"
#    "kubernetes.io/cluster/demo" = "owned"
#  }
#}
#
#resource "aws_subnet" "public-us-west-1b" {
#  vpc_id                  = aws_vpc.main.id
#  cidr_block              = "10.0.96.0/19"
#  availability_zone       = "us-west-2b"
#  map_public_ip_on_launch = true
#
#  tags = {
#    "Name"                       = "public-us-west-2b"
#    "kubernetes.io/role/elb"     = "1"
#    "kubernetes.io/cluster/demo" = "owned"
#  }
#}

resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "nat"
  }
}

//making 2 NAT adderses in case of failure
resource "aws_nat_gateway" "nat" {
  count = 2
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route = [
    {
      cidr_block                 = "0.0.0.0/0"
      nat_gateway_id             = aws_nat_gateway.nat[0].id
      carrier_gateway_id         = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      gateway_id                 = ""
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""
    },
  ]

  tags = {
    Name = "private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route = [
    {
      cidr_block                 = "0.0.0.0/0"
      gateway_id                 = aws_internet_gateway.igw.id
      nat_gateway_id             = ""
      carrier_gateway_id         = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""
    },
  ]

  tags = {
    Name = "public"
  }
}

#resource "aws_route_table_association" "private" {
#  subnet_id      = aws_subnet.private.id
#  route_table_id = aws_route_table.private.id
#}


#resource "aws_route_table_association" "public-us-west-2a" {
#  subnet_id      = aws_subnet.public-us-west-2a.id
#  route_table_id = aws_route_table.public.id
#}

#resource "aws_route_table_association" "public" {
#  subnet_id      = aws_subnet.public.id
#  route_table_id = aws_route_table.public.id
#}
resource "aws_route_table_association" "private" {
  count = 2

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public" {
  count = 2

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.private.id
}
