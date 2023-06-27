resource "aws_autoscaling_group" "asg" {
  name                = "${var.prefix}-asg"
  min_size            = 2
  max_size            = 5
  desired_capacity    = 4
  vpc_zone_identifier = aws_subnet.subnets[*].id
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
}
