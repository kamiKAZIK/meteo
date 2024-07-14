resource "aws_s3_bucket" "aparatus-timeseries-data-prod" {
  bucket = "eucentral1-aparatus-timeseries-data-prod"

  tags = {
    Name        = "Aparatus timeseries data bucket for PROD"
    Environment = "PROD"
  }
}
