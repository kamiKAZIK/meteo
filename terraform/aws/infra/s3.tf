resource "aws_s3_bucket" "meteo_s3_bucket_sensor_data" {
  bucket = "eucentral1-aparatus-meteo-sensor-data"
}

resource "aws_s3_bucket_acl" "meteo_s3_bucket_acl_sensor_data" {
  bucket = aws_s3_bucket.meteo_s3_bucket_sensor_data.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "meteo_s3_bucket_versioning_sensor_data" {
  bucket = aws_s3_bucket.meteo_s3_bucket_sensor_data.id
  versioning_configuration {
    status = "Enabled"
  }
}
