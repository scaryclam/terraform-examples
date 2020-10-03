resource "aws_ecs_cluster" "ecs-cluster-1" {
  name = "ecs-example-1"
}

data "template_file" "task_definition" {
  template = file("resources/container-definitions.json")

  vars = {
    task_version = var.task_version
    repo_url = var.repo_url
  }
}

resource "aws_ecs_task_definition" "example" {
  family = "example"
  container_definitions = data.template_file.task_definition.rendered
}

resource "aws_ecs_service" "example" {
  name = "example-1"
  cluster = aws_ecs_cluster.ecs-cluster-1.id
  task_definition = aws_ecs_task_definition.example.arn
  desired_count = 1
}

