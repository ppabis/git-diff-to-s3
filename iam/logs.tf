resource "aws_cloudwatch_log_group" "git_diff_log_group" {
  name              = "/aws/ecs/GitDiffCluster"
  retention_in_days = 7
}
