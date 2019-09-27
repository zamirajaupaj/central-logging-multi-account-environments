data "aws_caller_identity" "current" {}

data "archive_file" "index" {
  type        = "zip"
  source_file = "${path.module}/lambda/index.py"
  output_path = "${path.module}/index.zip"
}

resource "aws_lambda_function" "central_logging_cross_account" {
  filename         = "${path.module}/index.zip"
  description      = "Amazon Lambda send a log to CloudWatch."
  function_name    = "central-logging-cross-account"
  role             = "${aws_iam_role.central_logging_cross_account_lambda.arn}"
  handler          = "index.lambda_handler"
  runtime          = "python3.6"
  timeout          = "60"
  source_code_hash = "${data.archive_file.index.output_base64sha256}"
  tags             = "${local.tags}"
}

resource "aws_lambda_permission" "allow_cloudwatch_event_rule" {
  statement_id  = "1"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.central_logging_cross_account.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "arn:aws:events:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:rule/*"
}

resource "aws_cloudwatch_log_group" "lambda_central" {
  name              = "/aws/lambda/${aws_lambda_function.central_logging_cross_account.function_name}"
  retention_in_days = 30
  tags              = "${local.tags}"
}

resource "aws_iam_role" "central_logging_cross_account_lambda" {
  name               = "central-logging-lambda"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_central_logging_cross_account_lambda.json}"
}

data "aws_iam_policy_document" "assume_role_central_logging_cross_account_lambda" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "central_logging_cross_account_policy_lambda" {
  name   = "central-logging-policy-lambda"
  role   = "${aws_iam_role.central_logging_cross_account_lambda.id}"
  policy = "${data.aws_iam_policy_document.policy_central_logging_cross_account_lambda.json}"
}

data "aws_iam_policy_document" "policy_central_logging_cross_account_lambda" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "logs:DescribeLogGroups",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}
