provider "aws" {
  region = "eu-west-1"
}

provider "docker" {
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}
