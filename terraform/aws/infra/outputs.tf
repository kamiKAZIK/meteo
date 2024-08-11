output "s3_bucket_meteo_sensor_data_arn" {
  description = "Meteo sensor data S3 bucket ARN"
  value       = aws_s3_bucket.meteo_sensor_data.arn
}

output "iot_thing_meteo_sensor_esp32_arn" {
  description = "Meteo sensor ESP32 IOT thing ARN"
  value       = aws_iot_thing.meteo_sensor_esp32.arn
}

output "iot_thing_meteo_sensor_esp32_default_client_id" {
  description = "Meteo sensor ESP32 IOT thing default client ID"
  value       = aws_iot_thing.meteo_sensor_esp32.default_client_id
}

output "iot_certificate_meteo_sensor_esp32_device_certificate" {
  description = "Meteo sensor ESP32 IOT device certificate"
  value       = aws_iot_certificate.meteo_sensor_esp32.certificate_pem
  sensitive = true
}

output "iot_certificate_meteo_sensor_esp32_private_key" {
  description = "Meteo sensor ESP32 IOT private key"
  value       = aws_iot_certificate.meteo_sensor_esp32.private_key
  sensitive = true
}

output "iot_certificate_meteo_sensor_esp32_public_key" {
  description = "Meteo sensor ESP32 IOT public key"
  value       = aws_iot_certificate.meteo_sensor_esp32.public_key
  sensitive = true
}
