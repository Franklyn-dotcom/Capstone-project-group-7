resource "aws_db_instance" "rds_db" {
  identifier             = "${var.prefix}-rds-db"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  username               = "admin"
  password               = "mysecretpassword"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.sg.id]
}


# Creating an RDS database instance
resource "aws_db_instance" "rds_instance" {
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
}

# Configuring the RDS database to allow connections from the EKS cluster
resource "aws_security_group_rule" "rds_ingress_rule" {
  security_group_id        = aws_security_group.rds_sg.id
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg.id
}

# Outputting the RDS endpoint and port
output "rds_endpoint" {
  value = aws_db_instance.rds_instance.endpoint
}

output "rds_port" {
  value = aws_db_instance.rds_instance.port
}
