resource "aws_iam_role" "ScheduleRole" {
  name               = "GitDiffScheduleRole"
  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [ {
      "Effect": "Allow",
      "Principal": {
        "Service": "scheduler.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
      } ]
  }
  EOF
}

data "aws_iam_policy_document" "ScheduleRolePolicy" {
  statement {
    sid = "RunECSTask"
    actions = [
      "ecs:RunTask"
    ]
    resources = [var.task_definition_arn]
    condition {
      test     = "StringEquals"
      variable = "ecs:cluster"
      values   = [var.cluster_arn]
    }
  }

  statement {
    sid = "PassRoles"
    actions = [
      "iam:PassRole"
    ]
    resources = [var.task_role_arn, var.execution_role_arn]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }

}

resource "aws_iam_role_policy" "ScheduleRolePolicy" {
  name   = "ScheduleRolePolicy"
  role   = aws_iam_role.ScheduleRole.id
  policy = data.aws_iam_policy_document.ScheduleRolePolicy.json
}
