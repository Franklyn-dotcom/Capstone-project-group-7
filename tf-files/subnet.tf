# esource "aws_subnet" "private-eu-west-1a" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.0.0/19"
#   availability_zone = "eu-west-1a"

#   tags = {
#     "Name"                            = "private-eu-west-1a"
#     "kubernetes.io/role/internal-elb" = "1"
#     "kubernetes.io/cluster/demo"      = "owned"
#   }
# }

# resource "aws_subnet" "private-eu-west-1b" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.32.0/19"
#   availability_zone = "eu-west-1b"

#   tags = {
#     "Name"                            = "private-eu-west-1b"
#     "kubernetes.io/role/internal-elb" = "1"
#     "kubernetes.io/cluster/demo"      = "owned"
#   }
# }

# resource "aws_subnet" "public-eu-west-1a" {
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = "10.0.64.0/19"
#   availability_zone       = "eu-west-1a"
#   map_public_ip_on_launch = true

#   tags = {
#     "Name"                       = "public-eu-west-1a"
#     "kubernetes.io/role/elb"     = "1"
#     "kubernetes.io/cluster/demo" = "owned"
#   }
# }

# resource "aws_subnet" "public-eu-west-1b" {
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = "10.0.96.0/19"
#   availability_zone       = "eu-west-1b"
#   map_public_ip_on_launch = true

#   tags = {
#     "Name"                       = "public-eu-west-1b"
#     "kubernetes.io/role/elb"     = "1"
#     "kubernetes.io/cluster/demo" = "owned"
#   }
# }

# Create multiple subnets for the EKS cluster
resource "aws_subnet" "subnets" {
  count                   = length(var.subnet_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = element(var.availability_zone, count.index)
  cidr_block              = element(var.subnet_cidrs, count.index)
  map_public_ip_on_launch = count.index < 2 ? true : false

  tags = {
    #   Name = "${var.prefix}-${element(var.availability_zone, count.index)}" 
    Name = count.index < 2 ? "${var.prefix}-public-subnet-${count.index + 1}" : "${var.prefix}-private-subnet-${count.index + 1}"
  }
}

# Create a subnet group for the RDS database
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.prefix}-rds-subnet-group"
  subnet_ids = slice(aws_subnet.subnets[*].id, 0, 2)
}
