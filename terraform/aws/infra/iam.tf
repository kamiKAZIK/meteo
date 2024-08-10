data "aws_iam_policy_document" "meteo_iam_policy_document" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = [
        "iot.amazonaws.com",
        "s3.amazonaws.com",
        "firehose.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "meteo_iam_role" {
  name               = "meteo-iam-role"
  assume_role_policy = data.aws_iam_policy_document.meteo_iam_policy_document.json
}