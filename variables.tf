variable "repo_name" {
  description = "The name of the repository"
  type        = string
}

variable "region" {
  description = "The region in which the resources will be created"
  type        = string
  default     = "eu-west-1"
}

variable "external_repo_url" {
  description = "In case we don't want to use CodeCommit, we can use an external repository. It will override and discard repo_name."
  type        = string
  default     = ""
}
