output "meteo_data_name" {
  description = "S3 bucket name for Meteo data storage"
  value       = aws_s3_bucket.meteo_data.name
}
