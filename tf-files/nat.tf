resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "${var.prefix}-nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnets[0].id

  tags = {
    Name = "${var.prefix}-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}