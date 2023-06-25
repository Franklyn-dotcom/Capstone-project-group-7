# resource "aws_instance" "bastion" {
#   ami                         = "ami-007855ac798b5175e"
#   instance_type               = "t2.micro"
#   key_name                    = "conduit-key"
#   subnet_id                   = aws_subnet.public_subnet[0].id
#   vpc_security_group_ids      = [aws_security_group.bastion.id]
#   associate_public_ip_address = true

#   tags = { "Name" : "${var.prefix}-bastion" }
# }

# resource "aws_key_pair" "tf-key-pair" {
#   key_name   = "conduit-key"
#   public_key = tls_private_key.rsa.public_key_openssh
# }
# resource "tls_private_key" "rsa" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }
# resource "local_file" "tf-key" {
#   content  = tls_private_key.rsa.private_key_pem
#   filename = "conduit-key"
# }

