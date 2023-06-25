
# resource "aws_db_subnet_group" "main" {
#   name       = "${var.prefix}-db-subnet-gp"
#   subnet_ids = [aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id]

#   tags = { "Name" : "${var.prefix}-db-subnet-gp" }
# }

# resource "aws_db_instance" "my_rds_db" {
#   identifier             = "${var.prefix}-rds-db"
#   engine                 = "postgres"
#   engine_version         = "12.15"
#   instance_class         = "db.t2.micro"
#   allocated_storage      = 20
#   storage_type           = "gp2"
#   username               = var.db_user
#   password               = var.db_password
#   db_name                = "conduit"
#   db_subnet_group_name   = aws_db_subnet_group.main.name
#   vpc_security_group_ids = [aws_security_group.rds_sg.id]
#   skip_final_snapshot    = true
#   backup_retention_period = 0
#   apply_immediately      = true

#   tags = {
#     Name = "${var.prefix}-db"
#   }
# }
