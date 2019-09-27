data "aws_region" "current" {}

resource "aws_cloudwatch_log_subscription_filter" "central-logging" {
  name           = "central-logging-cross-Account"
  log_group_name = "${aws_cloudwatch_log_group.lambda_central.name}"
  filter_pattern = ""

  #Account Destination = 222222222222
  destination_arn = "arn:aws:logs:${data.aws_region.current.name}:222222222222:destination:central-logging"
  distribution    = "Random"
}
