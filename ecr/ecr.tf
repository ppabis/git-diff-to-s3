resource "aws_ecr_repository" "ecr_image" {
  name         = "pabiseu/gitdiff"
  force_delete = true
}

resource "docker_image" "ecr_image" {
  name = "${aws_ecr_repository.ecr_image.repository_url}:latest"
  build {
    context    = path.module
    dockerfile = "./Dockerfile"
  }
}

resource "null_resource" "docker_push" {
  depends_on = [docker_image.ecr_image]
  lifecycle {
    replace_triggered_by = [docker_image.ecr_image]
  }

  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${aws_ecr_repository.ecr_image.repository_url}"
  }

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.ecr_image.repository_url}:latest"
  }

  provider = null0
}
