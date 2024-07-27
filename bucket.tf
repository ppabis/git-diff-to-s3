resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_s3_bucket" "results_bucket" {
  bucket        = "git-diff-results-bucket-${random_string.suffix.result}"
  force_destroy = true
}

data "aws_iam_policy_document" "allow_task_role_put" {
  statement {
    sid       = "putobject"
    actions   = ["s3:PutObject", "s3:GetObject"]
    resources = ["${aws_s3_bucket.results_bucket.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [module.iam.task_role_arn]
    }
  }

  statement {
    sid       = "listbucket"
    actions   = ["s3:ListBucket", "s3:GetBucketLocation"]
    resources = [aws_s3_bucket.results_bucket.arn]
    principals {
      type        = "AWS"
      identifiers = [module.iam.task_role_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "allow_task_role_put" {
  bucket = aws_s3_bucket.results_bucket.bucket
  policy = data.aws_iam_policy_document.allow_task_role_put.json
}
