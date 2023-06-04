# Define the subnet CIDRs

variable "subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"] # Add more CIDRs as needed
}


variable "prefix" {
  type    = string
  default = "group7"
}

variable "availability_zone" {
  type    = list(string)
  default = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

variable "ami_id" {
  default = "ami-0eb260c4d5475b901"
}

variable "instance_type" {
  default = "t2.medium"
}

# variable "key_pair_name" {
#   default = 
# }
