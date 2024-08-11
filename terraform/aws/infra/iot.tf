data "aws_iam_policy_document" "meteo_sensor_esp32" {
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
      "arn:aws:iot:eu-central-1:${data.aws_caller_identity.current.account_id}:topic/$${iot:Connection.Thing.ThingName}/sensor-readings"
    ]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "iot:Subscribe"
    ]
    resources = [
      "arn:aws:iot:eu-central-1:${data.aws_caller_identity.current.account_id}:topicfilter/$${iot:Connection.Thing.ThingName}/sensor-readings"
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

resource "aws_iot_thing" "meteo_sensor_esp32" {
  name = "meteo-sensor-esp32"
}

resource "aws_iot_certificate" "meteo_sensor_esp32" {
  active = true
}

resource "aws_iot_thing_principal_attachment" "meteo_sensor_esp32" {
  principal = aws_iot_certificate.meteo_sensor_esp32.arn
  thing     = aws_iot_thing.meteo_sensor_esp32.name
}

resource "aws_iot_policy" "meteo_sensor_esp32" {
  name = "meteo-sensor-esp32"
  policy = data.aws_iam_policy_document.meteo_sensor_esp32.json
}

resource "aws_iot_policy_attachment" "meteo_sensor_esp32" {
  policy = aws_iot_policy.meteo_sensor_esp32.name
  target = aws_iot_certificate.meteo_sensor_esp32.arn
}

resource "aws_iot_topic_rule" "meteo_sensor_esp32" {
  name        = "meteo-sensor-esp32"
  enabled     = true
  sql         = "SELECT * FROM '${aws_iot_thing.esp32.default_client_id}/sensor-readings'"
  sql_version = "2016-03-23"
  firehose {
    delivery_stream_name = aws_kinesis_firehose_delivery_stream.meteo_sensor_readings.name
    role_arn = aws_iam_role.meteo_sensor_esp32.arn
  }
}
