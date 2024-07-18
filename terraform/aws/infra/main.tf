provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}



#
# resource "aws_glue_catalog_table" "esp32" {
#   name          = "esp32_readings"
#   database_name = "meteo"
#
#   table_type = "EXTERNAL_TABLE"
#
#   parameters = {
#     EXTERNAL              = "TRUE"
#     "parquet.compression" = "SNAPPY"
#   }
#
#   storage_descriptor {
#     location      = "s3://my-bucket/event-streams/my-stream"
#     input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
#     output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
#
#     ser_de_info {
#       name                  = "readings"
#       serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
#
#       parameters = {
#         "serialization.format" = 1
#       }
#     }
#
#     columns {
#       name = "qualifier"
#       type = "int"
#     }
#
#     columns {
#       name = "value"
#       type = "double"
#     }
#   }
# }
#
# resource "aws_iot_topic_rule" "esp32" {
#   name        = "MyRule"
#   description = "Example rule"
#   enabled     = true
#   sql         = "SELECT * FROM 'esp32/readings'"
#   sql_version = "2016-03-23"
#
#   firehose {
#     delivery_stream_name = ???
#     role_arn = ???
#   }
# }
#
# resource "aws_kinesis_firehose_delivery_stream" "esp32" {
#   name        = "esp32"
#   destination = "extended_s3"
#
#   extended_s3_configuration {
#     role_arn   = aws_iam_role.firehose_role.arn
#     bucket_arn = aws_s3_bucket.bucket.arn
#
#     buffering_size = 64
#
#     dynamic_partitioning_configuration {
#       enabled = "true"
#     }
#
#     # Example prefix using partitionKeyFromQuery, applicable to JQ processor
#     prefix              = "data/customer_id=!{partitionKeyFromQuery:customer_id}/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"
#     error_output_prefix = "errors/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/!{firehose:error-output-type}/"
#
#     processing_configuration {
#       enabled = "true"
#
#       # Multi-record deaggregation processor example
#       processors {
#         type = "RecordDeAggregation"
#         parameters {
#           parameter_name  = "SubRecordType"
#           parameter_value = "JSON"
#         }
#       }
#
#       # New line delimiter processor example
#       processors {
#         type = "AppendDelimiterToRecord"
#       }
#
#       # JQ processor example
#       processors {
#         type = "MetadataExtraction"
#         parameters {
#           parameter_name  = "JsonParsingEngine"
#           parameter_value = "JQ-1.6"
#         }
#         parameters {
#           parameter_name  = "MetadataExtractionQuery"
#           parameter_value = "{customer_id:.customer_id}"
#         }
#       }
#     }
#   }
# }