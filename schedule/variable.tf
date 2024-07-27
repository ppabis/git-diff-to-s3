### Needed by role
variable "cluster_arn" {
  description = "The ARN of the ECS cluster"
  type        = string
}

variable "task_definition_arn" {
  description = "The ARN of the ECS task definition"
  type        = string
}

variable "task_role_arn" {
  description = "The ARN of the ECS task role"
  type        = string
}

variable "execution_role_arn" {
  description = "The ARN of the ECS execution role"
  type        = string
}

### Needed by schedule runTask

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}

variable "sg_id" {
  description = "The ID of the security group"
  type        = string
}

variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "task_definition_arn_version" {
  description = "The ARN of the ECS task definition with version"
  type        = string
}

variable "repo_url" {
  description = "The HTTP URL of the Git repository"
  type        = string

}

variable "bucket_name" {
  description = "The name/path of the S3 bucket"
  type        = string
}

variable "parameter_name" {
  description = "The name of the parameter in the SSM parameter store (starts with /git-diff/...)"
  type        = string
}
