module "vpc" {
  source = "./vpc"
}

module "ecr" {
  source = "./ecr"
  region = var.region
}

module "iam" {
  source              = "./iam"
  codecommit_repo_arn = aws_codecommit_repository.CodeCommitRepo.arn
  ecr_repository_arn  = module.ecr.repository_arn
}

resource "aws_ecs_cluster" "cluster" {
  name = "GitDiffCluster"
}
