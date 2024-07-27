resource "aws_scheduler_schedule" "schedule" {

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ecs:runTask"
    role_arn = aws_iam_role.ScheduleRole.arn

    input = jsonencode({
      TaskDefinition = var.task_definition_arn_version,
      Cluster        = var.cluster_name,
      NetworkConfiguration = {
        AwsvpcConfiguration = {
          Subnets        = [var.subnet_id],
          SecurityGroups = [var.sg_id],
          AssignPublicIp = "ENABLED"
        }
      },
      LaunchType = "FARGATE",
      Overrides = {
        ContainerOverrides = [{
          Name = "git",
          Environment = [
            { Name = "GIT_REPO", Value = var.repo_url },
            { Name = "RESULTS_BUCKET", Value = var.bucket_name },
            { Name = "PARAMETER_NAME", Value = var.parameter_name }
          ]
        }]
      }
    })
  }

  flexible_time_window { mode = "OFF" }
  schedule_expression = "cron(0 0 * * ? *)" # Run every day at midnight
}
