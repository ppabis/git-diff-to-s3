module "schedule" {
  source = "./schedule"

  task_definition_arn = "${aws_ecs_task_definition.GitDiffTask.arn_without_revision}:*"
  task_role_arn       = module.iam.task_role_arn
  execution_role_arn  = module.iam.execution_role_arn
  cluster_arn         = aws_ecs_cluster.cluster.arn

  subnet_id                   = module.vpc.subnet_id
  sg_id                       = module.vpc.security_group
  cluster_name                = aws_ecs_cluster.cluster.name
  task_definition_arn_version = aws_ecs_task_definition.GitDiffTask.arn
  repo_url                    = aws_codecommit_repository.CodeCommitRepo.clone_url_http
  bucket_name                 = "${aws_s3_bucket.results_bucket.bucket}/${var.repo_name}"
  parameter_name              = "/git-diff/${var.repo_name}"
}
