output "iam_meteo_role_arn" {
  description = "Meteo IAM role ARN"
  value       = aws_iam_role.meteo_role.arn
}

# output "s3_meteo_data_arn" {
#   description = "S3 bucket ARN for Meteo data storage"
#   value       = aws_s3_bucket.meteo_data.arn
# }
#
# output "iot_thing_esp32_arn" {
#   description = "IOT thing ARN for esp32"
#   value       = aws_iot_thing.esp32.arn
# }
#
# output "iot_thing_esp32_default_client_id" {
#   description = "IOT thing default client ID for esp32"
#   value       = aws_iot_thing.esp32.default_client_id
# }
#
# output "iot_certificate_esp32_device_certificate" {
#   description = "IOT device certificate for esp32"
#   value       = aws_iot_certificate.esp32.certificate_pem
#   sensitive = true
# }
#
# output "iot_certificate_esp32_private_key" {
#   description = "IOT pricate key for esp32"
#   value       = aws_iot_certificate.esp32.private_key
#   sensitive = true
# }
#
# output "iot_certificate_esp32_public_key" {
#   description = "IOT device certificate for esp32"
#   value       = aws_iot_certificate.esp32.public_key
#   sensitive = true
# }