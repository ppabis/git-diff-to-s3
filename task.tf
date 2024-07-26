resource "aws_ecs_task_definition" "GitDiffTask" {
  family       = "GitDiffTask"
  network_mode = "awsvpc"
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
  cpu                      = 1024
  memory                   = 2048
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = module.iam.execution_role_arn
  task_role_arn            = module.iam.task_role_arn
  container_definitions = jsonencode(yamldecode(
    templatefile(
      "${path.module}/taskdef.yaml",
      {
        image          = "${module.ecr.repository}:latest",
        results_bucket = aws_s3_bucket.results_bucket.bucket,
        log_group      = module.iam.log_group_name,
        region         = var.region
      }
    )
  ))
}
