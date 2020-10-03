### Create VPCs
resource "aws_vpc" "example-vpc-1" {
    cidr_block = "172.16.1.0/24"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "example-vpc-1"
    }
}

resource "aws_vpc" "example-vpc-2" {
    # The provider option will use the provider for the target account
    provider = aws.target
    cidr_block = "172.16.2.0/24"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "example-vpc-2"
    }
}

### This is the peering stuff

resource "aws_vpc_peering_connection" "target-peer" {
    # The targets VPC owner ID (account number)
    peer_owner_id = data.aws_caller_identity.target-account.account_id
    # The targets VPC ID
    peer_vpc_id = aws_vpc.example-vpc-2.id
    # The source VPC ID
    vpc_id = aws_vpc.example-vpc-1.id
    peer_region = "eu-west-1"
    # Set to false as we're setting up an accepter below
    auto_accept = false
}

# If you don't want full automation on both sides, set the above resource's auto_accept to true and
# don't use the resource below to set the other side to auto_accept = true

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
    provider = aws.target
    vpc_peering_connection_id = aws_vpc_peering_connection.target-peer.id
    auto_accept = true

    tags = {
        Side = "Accepter"
    }
}

# If you want things in the VPCs to be able to talk to each other (and you probably do)...
# ...and yes, you need both
resource "aws_route" "vpc1-to-vpc2" {
    route_table_id = aws_vpc.example-vpc-1.main_route_table_id
    destination_cidr_block = aws_vpc.example-vpc-2.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.target-peer.id
}

resource "aws_route" "vpc2-to-vpc1" {
    provider = aws.target
    route_table_id = aws_vpc.example-vpc-2.main_route_table_id
    destination_cidr_block = aws_vpc.example-vpc-1.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.target-peer.id
}



### OPTIONAL THINGS:
# I've mainly used these to test and verify things are working as expected
# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "example-1" {
    vpc_id = aws_vpc.example-vpc-1.id
}

resource "aws_internet_gateway" "example-2" {
    provider = aws.target
    vpc_id = aws_vpc.example-vpc-2.id
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access-1" {
    route_table_id = aws_vpc.example-vpc-1.main_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example-1.id
}

resource "aws_route" "internet_access-2" {
    provider = aws.target
    route_table_id = aws_vpc.example-vpc-2.main_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example-2.id
}

# Create a subnets to launch our instances into
resource "aws_subnet" "example-eu-west-1a" {
    availability_zone = "eu-west-1a"
    vpc_id = aws_vpc.example-vpc-1.id
    cidr_block = "172.16.1.0/24"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "example-eu-west-2a" {
    provider = aws.target
    availability_zone = "eu-west-1a"
    vpc_id = aws_vpc.example-vpc-2.id
    cidr_block = "172.16.2.0/24"
    map_public_ip_on_launch = true
}

