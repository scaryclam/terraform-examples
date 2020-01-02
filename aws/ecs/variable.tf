variable "env_name" {
  description = "Environment name"
}

variable "state_bucket" {
  description = "Bucket that the state files are in"
}

variable "vpc_subnet_id" {
  description = "Subnet(s) on the VPC"
}

variable "key_file_path" {
  description = "Path for ssh key"
}

variable "security_group_vpc_id" {
  description = "VPC ID"
}

variable "profile" {
  description = "AWS Profile to use"
  default = "default"
}

