resource "aws_security_group" "eks_cluster_control_plane_sg" {
    name = "eks-example-control-plane-sg-${var.env_name}"
    description = "Security Group for the control plane"
    vpc_id = "${aws_vpc.example.id}"
}


resource "aws_security_group" "eks-example-node-sg" {
    name = "eks-example-sg-${var.env_name}"
    description = "Security Group for the nodes"
    vpc_id = "${aws_vpc.example.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "-1"
        self = true
    }

    ingress {
        from_port = 1025
        to_port = 65535
        protocol = "tcp"
        security_groups = ["${aws_security_group.eks_cluster_control_plane_sg.id}"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        security_groups = ["${aws_security_group.eks_cluster_control_plane_sg.id}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


# Separated rules that may cause circular dependancies
resource "aws_security_group_rule" "eks-node-to-control" {
  type = "egress"
  from_port = 1025
  to_port = 65535
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.eks-example-node-sg.id}"
  security_group_id = "${aws_security_group.eks_cluster_control_plane_sg.id}"
}

resource "aws_security_group_rule" "eks-control-to-node-https" {
  type = "egress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.eks-example-node-sg.id}"
  security_group_id = "${aws_security_group.eks_cluster_control_plane_sg.id}"
}

resource "aws_security_group_rule" "eks-node-to-control-https" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.eks-example-node-sg.id}"
  security_group_id = "${aws_security_group.eks_cluster_control_plane_sg.id}"
}

