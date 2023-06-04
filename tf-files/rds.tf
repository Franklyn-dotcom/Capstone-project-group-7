resource "aws_db_instance" "my_rds_db" {
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
