terraform {
  backend "s3" {
    bucket = "group7-bastion"
    region = "eu-west-1"
    key    = "bastion/terraform.tfstate"
  }
}
