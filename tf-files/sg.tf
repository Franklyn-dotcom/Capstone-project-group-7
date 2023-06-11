# Create a security group for the EKS cluster
resource "aws_security_group" "sg" {
  name        = "${var.prefix}-eks-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = aws_vpc.vpc.id

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
    from_port   = 1025
    to_port     = 65535
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
  vpc_id      = aws_vpc.vpc.id

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

# Creating a security group for the RDS database
resource "aws_security_group" "rds_sg" {
  name        = "${var.prefix}-security-group"
  description = "Security group for RDS database"

  vpc_id = aws_vpc.vpc.id

  # Ingress rule to allow incoming traffic on port 3306 from the EKS cluster security group
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.sg.id]
  }
}
