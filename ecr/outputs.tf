output "repository" {
  value = aws_ecr_repository.ecr_image.repository_url
}

output "repository_arn" {
  value = aws_ecr_repository.ecr_image.arn
}
