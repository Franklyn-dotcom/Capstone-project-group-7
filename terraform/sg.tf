# Create a security group for the EKS cluster
resource "aws_security_group" "eks-cluster" {
  name        = "${var.prefix}-eks-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = aws_vpc.altschool-capstone.id


  # Ingress rules
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-eks-cluster-sg"
  }
}

# create a security group for the worker nodes
resource "aws_security_group" "worker_sg" {
  name        = "${var.prefix}-worker-security-group"
  description = "Security group for worker nodes"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-worker-security-group"
  }
}

# Security Group for bastion instance
resource "aws_security_group" "bastion" {
  name        = "${var.prefix}-bastion"
  description = "Allow TLS inbound and outbound traffic for selected ports"
  vpc_id      = aws_vpc.altschool-capstone.id

  ingress {
    description = "SSH to Instance"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.private_subnet[0].cidr_block, aws_subnet.private_subnet[1].cidr_block]
  }

  tags = { "Name" : "${var.prefix}-bastion-SG" }

}

# Creating a security group for the RDS database
resource "aws_security_group" "rds_sg" {
  name        = "${var.prefix}-security-group"
  description = "Security group for RDS database"
  vpc_id = aws_vpc.altschool-capstone.id

  # Ingress rule to allow incoming traffic on port 5432 from the EKS cluster security group
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.eks-cluster.id, aws_security_group.bastion.id]
  }
}
