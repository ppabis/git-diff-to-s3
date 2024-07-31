resource "aws_codecommit_repository" "CodeCommitRepo" {
  count           = var.external_repo_url == "" ? 1 : 0
  repository_name = var.repo_name
}
