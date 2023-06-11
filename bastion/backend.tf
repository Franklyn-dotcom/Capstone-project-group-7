terraform {
  backend "s3" {
    bucket = "group7-bastion"
    region = "eu-west-2"
    key    = "bastion/terraform.tfstate"
  }
}
