resource "aws_kinesis_firehose_delivery_stream" "meteo_sensor_readings" {
  name        = "meteo-sensor-readings"
  destination = "extended_s3"
  extended_s3_configuration {
    role_arn            = aws_iam_role.meteo_firehose.arn
    bucket_arn          = aws_s3_bucket.meteo_sensor_data.arn
    buffering_size      = 128
    buffering_interval  = 300
    prefix              = "data/year=!{timestamp:yyyy}/month=!{timestamp:MM}/"
    error_output_prefix = "errors/year=!{timestamp:yyyy}/month=!{timestamp:MM}/!{firehose:error-output-type}/"
    data_format_conversion_configuration {
      input_format_configuration {
        deserializer {
          hive_json_ser_de {}
        }
      }
      output_format_configuration {
        serializer {
          parquet_ser_de {}
        }
      }
      schema_configuration {
        database_name = aws_glue_catalog_table.meteo_sensor_readings.database_name
        role_arn      = aws_iam_role.meteo_firehose.arn
        table_name    = aws_glue_catalog_table.meteo_sensor_readings.name
      }
    }
  }
}