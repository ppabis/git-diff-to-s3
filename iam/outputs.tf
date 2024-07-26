output "task_role_arn" {
  value = aws_iam_role.TaskRole.arn
}

output "execution_role_arn" {
  value = aws_iam_role.ExecutionRole.arn
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.git_diff_log_group.name
}
