resource "aws_codecommit_repository" "CodeCommitRepo" {
  repository_name = var.repo_name
}
