provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "jenkins-lockstate"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "jenkins-lockstate"
  }
}
