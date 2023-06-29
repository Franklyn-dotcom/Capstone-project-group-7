# Create a VPC for the EKS cluster
resource "aws_vpc" "altschool-capstone" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.prefix}-eks-vpc"
  }

}

# Create an internet gateway for the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.altschool-capstone.id

  tags = {
    Name = "${var.prefix}-eks-igw"
  }
}


# Create a public route table for the VPC
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.altschool-capstone.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.prefix}-public-route-table"
  }
}


# Public Subnet Creation
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.altschool-capstone.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = var.public_subnets_cidr[count.index]
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = true

  tags = { 
    "Name" : "${var.prefix}-public_subnet-${count.index + 1}"
    "kubernetes.io/role/elb"     = "1"
  }
}

# Private Subnets Creation
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.altschool-capstone.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = var.private_subnets_cidr[count.index]
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = false

  tags = { 
    "Name" : "${var.prefix}-private_subnet-${count.index + 1}"
    "kubernetes.io/role/internal-elb" = "1"
    }
}

# Associate the public route table with the subnets
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id

  depends_on = [aws_route_table.public_route_table]
}

resource "aws_eip" "elastic-ip" {
  # domain   = "vpc"
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.prefix}-elastic-ip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic-ip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    "Name" : "${var.prefix}-nat-gateway"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Private route table Creation
resource "aws_route_table" "private_route_table" {
  vpc_id            = aws_vpc.altschool-capstone.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    "Name" : "${var.prefix}-private-route-table"
  }
}

# Private route table association
resource "aws_route_table_association" "private_route_table_association" {
  count          = "${length(var.private_subnets_cidr)}"
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

 
