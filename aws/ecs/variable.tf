variable "vpc_subnet_id" {
  description = "Subnet(s) on the VPC"
}

variable "security_group_vpc_id" {
  description = "VPC ID"
}

variable "key_file_path" {
  description = "Path for ssh key"
}

variable "repo_url" {
  description = "The url to the docker repository. If using ECR or another non-docker-hub repo, you would use the full URL"
  default = "redis"
}

variable "task_version" {
  description = "The task version. This is usually the docker tag"
  default = "latest"
}

