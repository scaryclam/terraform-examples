# Create VPC for application environment
resource "aws_vpc" "example" {
    cidr_block = "10.12.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "example-vpc"
    }
}


# OPTIONAL THINGS:
# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "example" {
    vpc_id = aws_vpc.example.id
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
    route_table_id = aws_vpc.example.main_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
}

# Create a subnets to launch our instances into
resource "aws_subnet" "eks-example-eu-west-1a" {
    availability_zone = "eu-west-1a"
    vpc_id = aws_vpc.example.id
    cidr_block = "10.12.1.0/24"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "eks-example-eu-west-1b" {
    availability_zone = "eu-west-1b"
    vpc_id = aws_vpc.example.id
    cidr_block = "10.12.2.0/24"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "eks-example-eu-west-1c" {
    availability_zone = "eu-west-1c"
    vpc_id = aws_vpc.example.id
    cidr_block = "10.12.3.0/24"
    map_public_ip_on_launch = true
}
