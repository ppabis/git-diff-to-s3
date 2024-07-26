variable "repo_name" {
  description = "The name of the repository"
  type        = string
}

variable "region" {
  description = "The region in which the resources will be created"
  type        = string
  default     = "eu-west-1"
}
