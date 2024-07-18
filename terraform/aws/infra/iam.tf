data "aws_iam_policy_document" "meteo_assume_role_policy" {
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

resource "aws_iam_role" "meteo_role" {
  name               = "meteo-role"
  assume_role_policy = data.aws_iam_policy_document.meteo_assume_role_policy.json
}