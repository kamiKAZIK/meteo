/*
output "meteo_iam_role_arn" {
  description = "Meteo IAM role ARN"
  value       = aws_iam_role.meteo_iam_role.arn
}

output "esp32_iot_thing_arn" {
  description = "ESP32 IOT thing ARN"
  value       = aws_iot_thing.esp32_iot_thing.arn
}

output "esp32_iot_thing_default_client_id" {
  description = "ESP32 IOT thing default client ID"
  value       = aws_iot_thing.esp32_iot_thing.default_client_id
}

output "esp32_iot_certificate_device_certificate" {
  description = "ESP32 IOT device certificate"
  value       = aws_iot_certificate.esp32_iot_certificate.certificate_pem
  sensitive = true
}

output "esp32_iot_certificate_private_key" {
  description = "ESP32 IOT private key"
  value       = aws_iot_certificate.esp32_iot_certificate.private_key
  sensitive = true
}

output "esp32_iot_certificate_public_key" {
  description = "ESP32 IOT public key"
  value       = aws_iot_certificate.esp32_iot_certificate.public_key
  sensitive = true
}
*/

output "meteo_s3_bucket_sensor_data_arn" {
  description = "Meteo sensor data S3 bucket ARN"
  value       = aws_s3_bucket.meteo_s3_bucket_sensor_data.arn
}
