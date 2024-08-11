provider "aws" {
  region = var.aws_region
}

data "tls_certificate" "tfc_certificate" {
  url = "https://${var.tfc_hostname}"
}

resource "aws_iam_openid_connect_provider" "tfc_provider" {
  url             = data.tls_certificate.tfc_certificate.url
  client_id_list  = [
    var.tfc_aws_audience
  ]
  thumbprint_list = [
    data.tls_certificate.tfc_certificate.certificates[0].sha1_fingerprint
  ]
}

data "aws_iam_policy_document" "tfc_role" {
  statement {
    condition {
      test     = "StringEquals"
      variable = "${var.tfc_hostname}:aud"
      values = [
        "${one(aws_iam_openid_connect_provider.tfc_provider.client_id_list)}"
      ]
    }
    condition {
      test     = "StringLike"
      variable = "${var.tfc_hostname}:sub"
      values = [
        "organization:${var.tfc_organization_name}:project:${var.tfc_project_name}:workspace:${var.tfc_workspace_name}:run_phase:*"
      ]
    }
    effect    = "Allow"
    principals {
      type        = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.tfc_provider.arn
      ]
    }
    actions   = [
      "sts:AssumeRoleWithWebIdentity"
    ]
  }
}

resource "aws_iam_role" "tfc_role" {
  name = "tfc-role"
  assume_role_policy = data.aws_iam_policy_document.tfc_role.json
}

data "aws_iam_policy_document" "tfc_policy" {
  statement {
    effect    = "Allow"
    actions   = [
       "s3:*",
       "iot:*",
       "iam:*",
       "firehose:*",
       "glue:*"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "tfc_policy" {
  name        = "tfc-policy"
  policy = data.aws_iam_policy_document.tfc_policy.json
}

resource "aws_iam_role_policy_attachment" "tfc_policy_attachment" {
  role       = aws_iam_role.tfc_role.name
  policy_arn = aws_iam_policy.tfc_policy.arn
}
