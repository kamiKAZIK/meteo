resource "aws_kinesis_firehose_delivery_stream" "meteo_sensor_readings_kinesis_firehose_delivery_stream" {
  name        = "meteo-sensor-readings"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.meteo_iam_role.arn
    bucket_arn = aws_s3_bucket.meteo_s3_bucket_sensor_data.arn

    buffering_size = 64

    dynamic_partitioning_configuration {
      enabled = "true"
    }

    prefix              = "data/sensor_id=!{partitionKeyFromQuery:sensor_id}/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
    error_output_prefix = "errors/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/!{firehose:error-output-type}/"

    processing_configuration {
      enabled = "true"

      processors {
        type = "MetadataExtraction"
        parameters {
          parameter_name  = "JsonParsingEngine"
          parameter_value = "JQ-1.6"
        }
        parameters {
          parameter_name  = "MetadataExtractionQuery"
          parameter_value = "{sensor_id:.sensor_id}"
        }
      }
    }
  }
}
