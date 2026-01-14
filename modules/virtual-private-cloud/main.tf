provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "demo-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "demo-igw"
  }
}

resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = var.public_subnet_AZs[count.index]

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = var.private_subnet_AZs[count.index]

  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_eip" "EIP" {
  count  = length(var.public_subnet_cidr)
  domain = "vpc"
  # EIPs may require the IGW to exist prior to association, so an explicit
  # dependency can be useful here as well.
  depends_on = [aws_internet_gateway.igw]
}



resource "aws_nat_gateway" "NAT_GW" {
  count         = length(var.public_subnet_cidr)
  allocation_id = aws_eip.EIP[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  depends_on    = [aws_subnet.public_subnet]
  tags = {
    Name = "Demo NAT Gateway"
  }
}

resource "aws_route_table" "public_rt" {
  count = length(var.public_subnet_cidr)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.public_route_table_routes
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public Route Table"
  }
}


resource "aws_route_table" "private_rt" {
  count = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = var.private_route_table_routes
    nat_gateway_id = aws_nat_gateway.NAT_GW[count.index].id
  }

  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt[count.index].id
  depends_on     = [aws_route_table.public_rt]
}



resource "aws_route_table_association" "private_rt_assoc" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
  depends_on     = [aws_route_table.private_rt]
}
