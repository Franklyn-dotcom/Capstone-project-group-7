# resource "aws_s3_bucket" "terraform_state_bucket" {
#   bucket = "tfbucket"

#   tags = {
#     Name        = "${var.prefix}-Terraform State Bucket"
#     Environment = "dev"
#   }
# }
