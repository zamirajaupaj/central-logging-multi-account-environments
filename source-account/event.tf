resource "aws_cloudwatch_event_rule" "central_logging_cross_account" {
  name                = "central-logging"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "central_logging_cross_account" {
  target_id = "Lambda-Trigger"
  rule      = "${aws_cloudwatch_event_rule.central_logging_cross_account.id}"
  arn       = "${aws_lambda_function.central_logging_cross_account.arn}"
}
