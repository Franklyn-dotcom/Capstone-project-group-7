# Create an Auto Scaling Group (ASG) for worker nodes
resource "aws_launch_template" "launch_template" {
  name_prefix        = var.prefix
  image_id           = var.ami_id
  instance_type      = var.instance_type
  security_group_ids = [aws_security_group.worker_sg.id]
  # iam_instance_profile = aws_iam_instance_profile.worker_profile.name
  #   key_name                = var.key_pair_name
  #   user_data               = filebase64("user-data.sh")

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.prefix}-worker-node"
    }
  }
}
