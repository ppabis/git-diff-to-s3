module "vpc" {
  source = "./vpc"
}

module "ecr" {
  source = "./ecr"
  region = var.region
}

module "iam" {
  source                 = "./iam"
  codecommit_repo_arn    = var.external_repo_url == "" ? aws_codecommit_repository.CodeCommitRepo[0].arn : ""
  ecr_repository_arn     = module.ecr.repository_arn
  git_auth_parameter_arn = aws_ssm_parameter.git_http_auth.arn
}

resource "aws_ecs_cluster" "cluster" {
  name = "GitDiffCluster"
}
