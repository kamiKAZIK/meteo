terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60.0"
    }
  }
  cloud {
    organization = "aparatus"
    workspaces {
      name = "infra"
    }
  }
}