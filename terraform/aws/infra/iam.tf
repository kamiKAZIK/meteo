data "aws_iam_policy_document" "meteo_firehose_trust" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = [
        "firehose.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "meteo_iot_trust" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = [
        "iot.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "meteo_firehose_s3" {
  statement {
    effect  = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.meteo_sensor_data.arn}",
      "${aws_s3_bucket.meteo_sensor_data.arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "meteo_firehose_glue" {
  statement {
    effect  = "Allow"
    actions = [
      "glue:GetTable",
      "glue:GetTableVersion",
      "glue:GetTableVersions",

      "glue:GetDatabases",
      "glue:GetDatabase",
      "glue:GetTables",
      "glue:GetPartitions",
      "glue:GetPartition"
    ]
    resources = [
      "arn:aws:glue:eu-central-1:${data.aws_caller_identity.current.account_id}:catalog",
      aws_glue_catalog_database.meteo_sensors.arn,
      aws_glue_catalog_table.meteo_readings.arn
    ]
  }
  statement {
    effect  = "Allow"
    actions = [
      "glue:GetSchemaVersion"
    ]
    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "meteo_iot_firehose" {
  statement {
    effect  = "Allow"
    actions = [
      "firehose:PutRecord"
    ]
    resources = [
      aws_kinesis_firehose_delivery_stream.meteo_sensor_readings.arn
    ]
  }
}

resource "aws_iam_role" "meteo_firehose" {
  name               = "meteo-firehose"
  assume_role_policy = data.aws_iam_policy_document.meteo_firehose_trust.json
}

resource "aws_iam_policy" "meteo_firehose_s3" {
  name   = "meteo-firehose-s3"
  policy = data.aws_iam_policy_document.meteo_firehose_s3.json
}

resource "aws_iam_role_policy_attachment" "meteo_firehose_s3" {
  role       = aws_iam_role.meteo_firehose.name
  policy_arn = aws_iam_policy.meteo_firehose_s3.arn
}

resource "aws_iam_policy" "meteo_firehose_glue" {
  name   = "meteo-firehose-glue"
  policy = data.aws_iam_policy_document.meteo_firehose_glue.json
}

resource "aws_iam_role_policy_attachment" "meteo_firehose_glue" {
  role       = aws_iam_role.meteo_firehose.name
  policy_arn = aws_iam_policy.meteo_firehose_glue.arn
}

resource "aws_iam_role" "meteo_sensor_esp32" {
  name               = "meteo-sensor-esp32"
  assume_role_policy = data.aws_iam_policy_document.meteo_iot_trust.json
}

resource "aws_iam_policy" "meteo_sensor_esp32" {
  name   = "meteo-sensor-esp32"
  policy = data.aws_iam_policy_document.meteo_iot_firehose.json
}

resource "aws_iam_role_policy_attachment" "meteo_sensor_esp32" {
  role       = aws_iam_role.meteo_sensor_esp32.name
  policy_arn = aws_iam_policy.meteo_sensor_esp32.arn
}
