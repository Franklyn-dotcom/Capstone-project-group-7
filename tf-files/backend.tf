terraform {
    
  backend "s3" {
    bucket = "group7-bastion"
    region = "eu-west-2"
    key    = "tf-files/terraform.tfstate"
  }
}
