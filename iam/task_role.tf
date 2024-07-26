resource "aws_iam_role" "TaskRole" {
  name = "ECS_TaskRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

data "aws_caller_identity" "me" {}

data "aws_iam_policy_document" "TaskRolePolicy" {
  statement {
    sid = "Logs"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["${aws_cloudwatch_log_group.git_diff_log_group.arn}:*"]
  }

  statement {
    sid = "SSMParameterStore"
    actions = [
      "ssm:GetParameter",
      "ssm:PutParameter",
      "ssm:DeleteParameter"
    ]
    resources = ["arn:aws:ssm:eu-west-1:${data.aws_caller_identity.me.account_id}:parameter/git-diff/*"]
  }

  statement {
    sid = "CodeCommitClone"
    actions = [
      "codecommit:GitPull"
    ]
    resources = [var.codecommit_repo_arn]
  }
}

resource "aws_iam_role_policy" "TaskRolePolicy" {
  name = "TaskRolePolicy"
  role = aws_iam_role.TaskRole.id

  policy = data.aws_iam_policy_document.TaskRolePolicy.json

}
