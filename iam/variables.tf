variable "codecommit_repo_arn" {
  description = "The ARN of the CodeCommit repository"
  type        = string
  default     = ""
}

variable "ecr_repository_arn" {
  description = "The ARN of the ECR repository"
  type        = string
}

variable "git_auth_parameter_arn" {
  description = "The ARN of the SSM parameter for Git authentication"
  type        = string
}
