resource "aws_security_group" "example-sg" {
    name = "example-sg-${var.env_name}"
    description = "Security Group for the instances"
    vpc_id = "${var.security_group_vpc_id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
