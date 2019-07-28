resource "aws_launch_configuration" "eks-example-launch-conf" {
  name_prefix = "eks-example-launch-conf-${var.env_name}"
  image_id = "ami-00ac2e6b3cb38a9b9"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.example-instance-key.key_name}"
  security_groups = ["${aws_security_group.eks-example-node-sg.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.eks-instance-profile.id}"
  associate_public_ip_address = true

  user_data = <<-EOF
   #!/bin/bash
   set -o xtrace
   /etc/eks/bootstrap.sh "${aws_eks_cluster.eks-cluster-1.name}"
   EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "eks-example-asg" {
  name = "eks-example-asg"
  launch_configuration = "${aws_launch_configuration.eks-example-launch-conf.name}"
  vpc_zone_identifier = ["${aws_vpc.example.id}"]
  min_size = 1
  max_size = 2
  desired_capacity = 1

  lifecycle {
    create_before_destroy = true
  }
}
