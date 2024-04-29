resource "aws_vpc" "vpc" {
  cidr_block       = var.VPC_CIDR
  instance_tenancy = "default"
  tags = {
    Name = "${var.PROJECT_NAME}-vpc"
  }
}


data "aws_availability_zones" "az" {}

resource "aws_subnet" "public-subnet-1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.VPC_1A_SUBNET
  availability_zone       = data.aws_availability_zones.az.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.PROJECT_NAME}-pub-sub-1a"
  }
}

resource "aws_subnet" "public-subnet-1b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.VPC_1B_SUBNET
  availability_zone       = data.aws_availability_zones.az.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.PROJECT_NAME}-pub-sub-1b"
  }
}

resource "aws_subnet" "private-subnet-2a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.VPC_2A_SUBNET
  availability_zone       = data.aws_availability_zones.az.names[0] # us-east-1a
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.PROJECT_NAME}-pri-sub-2a"
  }
}

resource "aws_subnet" "private-subnet-2b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.VPC_2B_SUBNET
  availability_zone       = data.aws_availability_zones.az.names[1] # us-east-1b
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.PROJECT_NAME}-pri-sub-2b"
  }
}

resource "aws_subnet" "private-subnet-3a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.VPC_3A_SUBNET
  availability_zone       = data.aws_availability_zones.az.names[0] # us-east-1a
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.PROJECT_NAME}-pri-sub-3a"
  }
}

resource "aws_subnet" "private-subnet-3b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.VPC_3B_SUBNET
  availability_zone       = data.aws_availability_zones.az.names[1] # us-east-1b
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.PROJECT_NAME}-pri-sub-3b"
  }
}

#############################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.PROJECT_NAME}-igw"
  }
}


# Create eigw for ipv6 IPs in private subnets
resource "aws_egress_only_internet_gateway" "eigw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.PROJECT_NAME}-eigw"
  }
}
########################################################
resource "aws_eip" "nat-gw-eip" {
  vpc = true

  tags = {
    Name = "${var.PROJECT_NAME}-nat-gw-eip"
  }
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-gw-eip.id
  subnet_id     = aws_subnet.public-subnet-1a.id

  tags = {
    Name = "${var.PROJECT_NAME}-nat-gw"
  }
  depends_on = [aws_internet_gateway.igw]
}
###################################################################

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.PROJECT_NAME}-pub-route-table"
  }
}

###################################################################

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.eigw.id
  }
  tags = {
    Name = "${var.PROJECT_NAME}-Pri-route-table"
  }
}

##################################################################
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public-subnet-1a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public-subnet-1b.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.private-subnet-2a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.private-subnet-2b.id
  route_table_id = aws_route_table.private_route_table.id
}