resource "aws_s3_bucket" "meteo_sensor_data" {
  bucket = "eucentral1-aparatus-meteo-sensor-data"
}

resource "aws_s3_bucket_versioning" "meteo_sensor_data" {
  bucket = aws_s3_bucket.meteo_sensor_data.id
  versioning_configuration {
    status = "Enabled"
  }
}
