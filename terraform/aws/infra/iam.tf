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
  statement = {
    effect  = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObjectAcl"
    ]
    resources = [
      aws_s3_bucket.meteo_s3_bucket_sensor_data.arn
    ]
  }
}

data "aws_iam_policy_document" "meteo_glue_policy_document" {
  statement = {
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

resource "aws_iam_role" "meteo_iam_role" {
  name               = "meteo-iam-role"
  assume_role_policy = data.aws_iam_policy_document.meteo_assume_role_policy_document.json
}

resource "aws_iam_role_policy_attachment" "meteo_s3_policy_attachment" {
  role   = aws_iam_role.meteo_iam_role.name
  policy = aws_iam_policy.meteo_s3_policy_document.json
}

resource "aws_iam_role_policy_attachment" "meteo_glue_policy_attachment" {
  role   = aws_iam_role.meteo_iam_role.name
  policy = aws_iam_policy.meteo_glue_policy_document.json
}
