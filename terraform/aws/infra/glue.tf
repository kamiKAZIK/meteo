resource "aws_glue_catalog_database" "meteo_glue_catalog_database" {
  name = "meteo"
}

resource "aws_glue_catalog_table" "meteo_sensor_readings_glue_catalog_table" {
  name          = "meteo_sensor_readings"
  database_name = aws_glue_catalog_database.meteo_glue_catalog_database.name
  table_type = "EXTERNAL_TABLE"
  parameters = {
    EXTERNAL              = "TRUE"
    "parquet.compression" = "SNAPPY"
  }
  storage_descriptor = {
    location      = "s3://${aws_s3_bucket.meteo_s3_bucket_sensor_data.bucket}/data"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
    ser_de_info = {
      name                  = "readings"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
      parameters = {
        "serialization.format" = 1
      }
    }
    columns {
      name = "sensor_id"
      type = "string"
    }
    columns {
      name = "qualifier"
      type = "int"
    }
    columns {
      name = "value"
      type = "double"
    }
  }
}
