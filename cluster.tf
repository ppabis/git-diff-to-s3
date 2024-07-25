module "vpc" {
  source = "./vpc"
}

resource "aws_ecs_cluster" "cluster" {
  name = "GitDiffCluster"
}
