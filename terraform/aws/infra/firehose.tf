/*
resource "aws_kinesis_firehose_delivery_stream" "meteo_sensor_readings_kinesis_firehose_delivery_stream" {
  name        = "meteo-sensor-readings"
  destination = "extended_s3"
  extended_s3_configuration {
    role_arn            = aws_iam_role.meteo_iam_role.arn
    bucket_arn          = aws_s3_bucket.meteo_s3_bucket_sensor_data.arn
    buffering_size      = 64
    buffering_interval  = 10
    prefix              = "data/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
    error_output_prefix = "errors/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/!{firehose:error-output-type}/"
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
        database_name = aws_glue_catalog_table.meteo_sensor_readings_glue_catalog_table.database_name
        role_arn      = aws_iam_role.meteo_iam_role.arn
        table_name    = aws_glue_catalog_table.meteo_sensor_readings_glue_catalog_table.name
      }
    }
  }
}
*/

resource "aws_kinesis_firehose_delivery_stream" "meteo_sensor_readings" {
  name        = "meteo-sensor-readings"
  destination = "extended_s3"
  extended_s3_configuration {
    role_arn            = aws_iam_role.meteo_data_sink.arn
    bucket_arn          = aws_s3_bucket.meteo_sensor_data.arn
    buffering_size      = 64
    buffering_interval  = 10
    prefix              = "data/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
    error_output_prefix = "errors/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/!{firehose:error-output-type}/"
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
        database_name = aws_glue_catalog_table.meteo_sensors.database_name
        role_arn      = aws_iam_role.meteo_glue.arn
        table_name    = aws_glue_catalog_table.meteo_readings.name
      }
    }
  }
}