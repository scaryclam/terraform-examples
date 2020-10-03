resource "aws_launch_configuration" "example-launch-conf" {
  name_prefix = "example-launch-conf-"
  image_id = "ami-0acc9f8be17a41897"
  instance_type = "t2.micro"
  key_name = aws_key_pair.example-instance-key.key_name
  security_groups = [aws_security_group.example-sg.id]
  iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.id
  associate_public_ip_address = true

  user_data = <<-EOF
   #!/bin/bash
   mkdir -p  /etc/ecs
   echo "ECS_CLUSTER=${aws_ecs_cluster.ecs-cluster-1.name}" >> /etc/ecs/ecs.config
   sudo yum install -y aws-cli
   aws ecr get-login --no-include-email --region eu-west-1
   EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example-asg" {
  name = "example-asg"
  launch_configuration = aws_launch_configuration.example-launch-conf.name
  vpc_zone_identifier = [var.vpc_subnet_id]
  min_size = 1
  max_size = 2
  desired_capacity = 1

  lifecycle {
    create_before_destroy = true
  }
}
