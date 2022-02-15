terraform {
  required_version = ">= 1.0.1"
  required_providers {
    aws = {
      version = ">= 3.47.0, < 4.0.0"
      source  = "hashicorp/aws"
    }
    github = {
      version = ">= 4.4.0"
      source  = "integrations/github"
    }
  }
}
