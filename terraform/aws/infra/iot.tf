resource "aws_iot_thing" "esp32_iot_thing" {
  name = "esp32-iot-thing"
}

resource "aws_iot_certificate" "esp32_iot_certificate" {
  active = true
}

resource "aws_iot_thing_principal_attachment" "esp32_iot_thing_principal_attachment" {
  principal = aws_iot_certificate.esp32_iot_certificate.arn
  thing     = aws_iot_thing.esp32_iot_thing.name
}

data "aws_iam_policy_document" "esp32_iam_policy_document" {
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
      "arn:aws:iot:eu-central-1:${data.aws_caller_identity.current.account_id}:client/$${iot:Connection.Thing.ThingName}"
    ]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "iot:Publish"
    ]
    resources = [
      "arn:aws:iot:eu-central-1:${data.aws_caller_identity.current.account_id}:topic/$${iot:Connection.Thing.ThingName}/readings"
    ]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "iot:Subscribe"
    ]
    resources = [
      "arn:aws:iot:eu-central-1:${data.aws_caller_identity.current.account_id}:topicfilter/$${iot:Connection.Thing.ThingName}/readings"
    ]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "iot:Connect"
    ]
    resources = [
      "arn:aws:iot:eu-central-1:${data.aws_caller_identity.current.account_id}:client/esp32-sub"
    ]
  }
}

resource "aws_iot_policy" "esp32_iot_policy" {
  name = "esp32-iot-policy"
  policy = data.aws_iam_policy_document.esp32_iam_policy_document.json
}

resource "aws_iot_policy_attachment" "esp32_iot_policy_attachment" {
  policy = aws_iot_policy.esp32_iot_policy.name
  target = aws_iot_certificate.esp32_iot_certificate.arn
}

resource "aws_iot_topic_rule" "esp32_iot_topic_rule" {
  name        = "esp32_sensor_readings"
  enabled     = true
  sql         = "SELECT * FROM '${aws_iot_thing.esp32_iot_thing.default_client_id}/sensor-readings'"
  sql_version = "2016-03-23"

  firehose {
    delivery_stream_name = aws_kinesis_firehose_delivery_stream.meteo_sensor_readings_kinesis_firehose_delivery_stream.name
    role_arn = aws_iam_role.meteo_iam_role.arn
  }
}
