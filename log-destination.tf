resource "aws_cloudwatch_log_destination" "cloudwatch_kinesis_logging" {
  name       = "central-logging"
  role_arn   = "${aws_iam_role.cloudwatch_kinesis_logging.arn}"
  target_arn = "${aws_kinesis_stream.central_logging_cross_account.arn}"
}

resource "aws_iam_role" "cloudwatch_kinesis_logging" {
  description        = "grants Amazon CloudWatch Logs permissions to put data into the Kinesis Stream"
  name               = "cloudwatch-kinesis-logging"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_central_logging_cross_account_log.json}"
}

data "aws_iam_policy_document" "assume_role_central_logging_cross_account_log" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["logs.eu-west-1.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "central_logging_cross_account_policy_log" {
  name   = "policy_central_logging_cross_account_log"
  role   = "${aws_iam_role.cloudwatch_kinesis_logging.id}"
  policy = "${data.aws_iam_policy_document.policy_central_logging_cross_account_log.json}"
}

data "aws_iam_policy_document" "policy_central_logging_cross_account_log" {
  statement {
    actions = ["kinesis:PutRecord"]

    resources = [
      "${aws_kinesis_stream.central_logging_cross_account.arn}",
    ]
  }

  statement {
    actions   = ["iam:PassRole"]
    resources = ["${aws_iam_role.cloudwatch_kinesis_logging.arn}"]
  }
}

data "aws_iam_policy_document" "central_logging_cross_account_destination_policy" {
  statement {
    effect = "Allow"

    principals {
      type = "AWS"

      # Number of Source Account where the logs are coming from
      identifiers = [
        "11111111111",
      ]
    }

    actions = [
      "logs:PutSubscriptionFilter",
    ]

    resources = [
      "${aws_cloudwatch_log_destination.cloudwatch_kinesis_logging.arn}",
    ]
  }
}

resource "aws_cloudwatch_log_destination_policy" "central_logging_cross_account_destination_policy" {
  destination_name = "${aws_cloudwatch_log_destination.cloudwatch_kinesis_logging.name}"
  access_policy    = "${data.aws_iam_policy_document.central_logging_cross_account_destination_policy.json}"
}
