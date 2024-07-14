provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "meteo_data" {
  bucket = "eucentral1-aparatus-meteo-data"

  tags = {
    Name        = "Aparatus Meteo data storage"
    Environment = "PROD"
  }
}
