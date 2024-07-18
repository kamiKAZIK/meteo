terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.49.0"
    }
  }
  backend "s3" {
    bucket = "eucentral1-aparatus-terraform-state"
    key    = "meteo/trust"
    region = "eu-central-1"
  }
}
