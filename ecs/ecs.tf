resource "aws_ecs_cluster" "ecs-cluster-1" {
  name = "ecs-${var.env_name}-1"
}

data "template_file" "task_definition" {
  template = "${file("resources/container-definitions.json")}"

  vars = {
    # replace with task version. The original I created uses something more dynamic,
    # so you'll want to just enter it yourself for now
    task_version = "${var.task_version}"
    # Put your repo url here. This will try and pull from a remote state, so probably don't
    # want to do this for existing repos
    repo_url = "${data.terraform_remote_state.base.ecr_repo_url}"
  }
}

resource "aws_ecs_task_definition" "example" {
  family = "example"
  container_definitions = "${data.template_file.task_definition.rendered}"
}

resource "aws_ecs_service" "example" {
  name = "example-${var.env_name}"
  cluster = "${data.terraform_remote_state.environment.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.example.arn}"
  desired_count = 1
}

output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.ecs-cluster-1.id}"
}
