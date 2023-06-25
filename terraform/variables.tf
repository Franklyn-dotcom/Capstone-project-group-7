# Define the subnet CIDRs

variable "public_subnets_cidr" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  type    = list(any)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "prefix" {
  type    = string
  default = "group7"
}

variable "availability_zone" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "ami_id" {
  default = "ami-0eb260c4d5475b901"
}

variable "instance_type" {
  default = "t2.medium"
}

# variable "db_user" {
#   description = "database user"
# }

# variable "db_password" {
#   description = "database password"
# }

# variable db_name {
#   description = "database name"
# }
