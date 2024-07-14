provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "meteo_data" {
  bucket = "eucentral1-aparatus-meteo-data"

  tags = {
    Name        = "Aparatus Meteo data storage"
    Environment = "PROD"
  }
}

resource "aws_iot_thing" "esp32" {
  name = "esp32"
}

resource "aws_iot_certificate" "esp32" {
  active = true
}

resource "aws_iot_thing_principal_attachment" "esp32" {
  principal = aws_iot_certificate.esp32.arn
  thing     = aws_iot_thing.esp32.name
}

data "aws_iam_policy_document" "esp32" {
  statement {
    condition {
      test     = "Bool"
      variable = "iot:Connection.Thing.IsAttached"

      values = [
        "true"
      ]
    }
    effect    = "Allow"
    actions   = [
      "iot:Connect"
    ]
    resources = [
      "arn:aws:iot:eu-central-1:975050052634:client/$${iot:Connection.Thing.ThingName}"
    ]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "iot:Publish"
    ]
    resources = [
      "arn:aws:iot:eu-central-1:975050052634:topic/$${iot:Connection.Thing.ThingName}/readings"
    ]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "iot:Subscribe"
    ]
    resources = [
      "arn:aws:iot:eu-central-1:975050052634:topicfilter/$${iot:Connection.Thing.ThingName}/readings"
    ]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "iot:Connect"
    ]
    resources = [
      "arn:aws:iot:eu-central-1:975050052634:client/esp32-sub"
    ]
  }
}

resource "aws_iot_policy" "esp32" {
  name = "esp32"
  policy = data.aws_iam_policy_document.esp32.json
}

resource "aws_iot_policy_attachment" "esp32" {
  policy = aws_iot_policy.esp32.name
  target = aws_iot_certificate.esp32.arn
}

