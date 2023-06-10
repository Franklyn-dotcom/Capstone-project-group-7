resource "aws_instance" "bastion" {
  ami           = "ami-0eb260c4d5475b901"
  instance_type = var.instance_type
  # key_name                    = "bastion"
  subnet_id                   = aws_subnet.bastion-subnet.id
  vpc_security_group_ids      = [aws_default_security_group.bastion-sg.id]
  availability_zone           = var.avail_zone
  associate_public_ip_address = true
  user_data                   = file("script.sh")
  tags = {
    Name = "bastion-server"
  }
}
