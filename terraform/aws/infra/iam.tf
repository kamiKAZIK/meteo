/*
data "aws_iam_policy_document" "meteo_assume_role_policy_document" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = [
        "iot.amazonaws.com",
        "s3.amazonaws.com",
        "firehose.amazonaws.com",
        "glue.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "meteo_s3_policy_document" {
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
      aws_s3_bucket.meteo_s3_bucket_sensor_data.arn,
      "${aws_s3_bucket.meteo_s3_bucket_sensor_data.arn}"
    ]
  }
}

data "aws_iam_policy_document" "meteo_glue_policy_document" {
  statement {
    effect  = "Allow"
    actions = [
      "glue:GetTable",
      "glue:GetTableVersion",
      "glue:GetTableVersions"
    ]
    resources = [
      "arn:aws:glue:eu-central-1:${data.aws_caller_identity.current.account_id}:catalog",
      aws_glue_catalog_database.meteo_glue_catalog_database.arn,
      aws_glue_catalog_table.meteo_sensor_readings_glue_catalog_table.arn
    ]
  }
}

data "aws_iam_policy_document" "meteo_firehose_policy_document" {
  statement {
    effect  = "Allow"
    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch"
    ]
    resources = [
      aws_kinesis_firehose_delivery_stream.meteo_sensor_readings_kinesis_firehose_delivery_stream.arn
    ]
  }
}

resource "aws_iam_role" "meteo_iam_role" {
  name               = "meteo-iam-role"
  assume_role_policy = data.aws_iam_policy_document.meteo_assume_role_policy_document.json
}

resource "aws_iam_policy" "meteo_s3_policy" {
  name        = "meteo-s3"
  policy      = data.aws_iam_policy_document.meteo_s3_policy_document.json
}

resource "aws_iam_policy" "meteo_glue_policy" {
  name        = "meteo-glue"
  policy      = data.aws_iam_policy_document.meteo_glue_policy_document.json
}

resource "aws_iam_policy" "meteo_firehose_policy" {
  name        = "meteo-firehose"
  policy      = data.aws_iam_policy_document.meteo_firehose_policy_document.json
}

resource "aws_iam_role_policy_attachment" "meteo_s3_policy_attachment" {
  role       = aws_iam_role.meteo_iam_role.name
  policy_arn = aws_iam_policy.meteo_s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "meteo_glue_policy_attachment" {
  role       = aws_iam_role.meteo_iam_role.name
  policy_arn = aws_iam_policy.meteo_glue_policy.arn
}

resource "aws_iam_role_policy_attachment" "meteo_firehose_policy_attachment" {
  role       = aws_iam_role.meteo_iam_role.name
  policy_arn = aws_iam_policy.meteo_firehose_policy.arn
}
*/

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

resource "aws_iam_role" "meteo_esp32" {
  name               = "meteo-esp32"
  assume_role_policy = data.aws_iam_policy_document.meteo_iot_trust.json
}

resource "aws_iam_policy" "meteo_esp32" {
  name   = "meteo-esp32"
  policy = data.aws_iam_policy_document.meteo_iot_firehose.json
}

resource "aws_iam_role_policy_attachment" "meteo_esp32" {
  role       = aws_iam_role.meteo_esp32.name
  policy_arn = aws_iam_policy.meteo_esp32.arn
}