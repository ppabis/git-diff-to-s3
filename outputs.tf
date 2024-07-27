## Outputs are mostly for running the thing manually.

output "task_definition_arn" {
  value = aws_ecs_task_definition.GitDiffTask.arn
}

output "subnet_id" {
  value = module.vpc.subnet_id
}

output "sg_id" {
  value = module.vpc.security_group
}

output "repo_name" {
  value = aws_codecommit_repository.CodeCommitRepo.clone_url_http
}

output "bucket_name" {
  value = aws_s3_bucket.results_bucket.bucket
}

output "region" {
  value = var.region
}

output "cluster_name" {
  value = aws_ecs_cluster.cluster.name
}