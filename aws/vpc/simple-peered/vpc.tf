# Create VPC for application environment
resource "aws_vpc" "example-vpc-1" {
    cidr_block = "172.16.1.0/24"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags {
        Name = "example-vpc-1"
    }
}

resource "aws_vpc" "example-vpc-2" {
    cidr_block = "172.16.2.0/24"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags {
        Name = "example-vpc-2"
    }
}

# This is the peering stuff
# GOTCHA ALERT! With the auto_accept value set to false, or not including it at all,
# you will need to MANUALLY accept the connection in the AWS console!
# If the requester and accepter are not the same owner, this will need to be done!
resource "aws_vpc_peering_connection" "example-peer" {
    # This should be your AWS account ID. You can set this variable, either
    # by using a .tfvars file, or just by doing something like:
    # $ terraform plan --var account_owner_id = ABCDE12345
    peer_owner_id = "${var.account_owner_id}"
    peer_vpc_id = "${aws_vpc.example-vpc-1.id}"
    vpc_id = "${aws_vpc.example-vpc-2.id}"
    # Cannot use this if we have auto_accept set to true
    #peer_region = "eu-west-1"
    auto_accept = true
}


# If you want things in the VPCs to be able to talk to each other (and you probably do)...
# ...and yes, you need both
resource "aws_route" "vpc1-to-vpc2" {
    route_table_id = "${aws_vpc.example-vpc-1.main_route_table_id}"
    destination_cidr_block = "${aws_vpc.example-vpc-2.cidr_block}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.example-peer.id}"
}

resource "aws_route" "vpc2-to-vpc1" {
    route_table_id = "${aws_vpc.example-vpc-2.main_route_table_id}"
    destination_cidr_block = "${aws_vpc.example-vpc-1.cidr_block}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.example-peer.id}"
}



# OPTIONAL THINGS:
# I've mainly used these to test and verify things are working as expected
# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "example-1" {
    vpc_id = "${aws_vpc.example-vpc-1.id}"
}

resource "aws_internet_gateway" "example-2" {
    vpc_id = "${aws_vpc.example-vpc-2.id}"
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access-1" {
    route_table_id = "${aws_vpc.example-vpc-1.main_route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.example-1.id}"
}

resource "aws_route" "internet_access-2" {
    route_table_id = "${aws_vpc.example-vpc-2.main_route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.example-2.id}"
}

# Create a subnets to launch our instances into
resource "aws_subnet" "example-eu-west-1a" {
    availability_zone = "eu-west-1a"
    vpc_id = "${aws_vpc.example-vpc-1.id}"
    cidr_block = "172.16.1.0/24"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "example-eu-west-2a" {
    availability_zone = "eu-west-1a"
    vpc_id = "${aws_vpc.example-vpc-2.id}"
    cidr_block = "172.16.2.0/24"
    map_public_ip_on_launch = true
}

