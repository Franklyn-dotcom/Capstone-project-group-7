resource "aws_vpc" "bastion-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "bastion-vpc"
  }
}

resource "aws_subnet" "bastion-subnet" {
  vpc_id            = aws_vpc.bastion-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name = "bastion-subnet"
  }
}

resource "aws_internet_gateway" "bastion-igw" {
  vpc_id = aws_vpc.bastion-vpc.id
  tags = {
    Name = "bastion-igw"
  }
}

resource "aws_default_route_table" "bastion-rtb" {
  default_route_table_id = aws_vpc.bastion-vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bastion-igw.id
  }
  tags = {
    Name = "bastion-rtb"
  }
}

resource "aws_default_security_group" "bastion-sg" {
  vpc_id = aws_vpc.bastion-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "bastion-sg"
  }
}
