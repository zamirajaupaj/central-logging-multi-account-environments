data "archive_file" "index" {
  type        = "zip"
  source_file = "${path.module}/lambda/index.py"
  output_path = "${path.module}/index.zip"
}

resource "aws_lambda_function" "central_logging_cross_account" {
  filename         = "${path.module}/index.zip"
  description      = "Amazon Lambda send a log to sumo logic."
  function_name    = "central-logging"
  role             = "${aws_iam_role.central_logging_cross_account_lambda.arn}"
  handler          = "index.lambda_handler"
  runtime          = "python2.7"
  timeout          = "60"
  source_code_hash = "${data.archive_file.index.output_base64sha256}"
  tags             = "${local.tags}"
}

resource "aws_lambda_event_source_mapping" "central_logging_cross_account_kinesis" {
  event_source_arn  = "${aws_kinesis_stream.central_logging_cross_account.arn}"
  function_name     = "${aws_lambda_function.central_logging_cross_account.arn}"
  starting_position = "LATEST"
}

resource "aws_lambda_permission" "central-logging" {
  statement_id  = "central-logging-sumo"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.central_logging_cross_account.function_name}"
  principal     = "logs.eu-west-1.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.lambda_central.arn}"
}

resource "aws_cloudwatch_log_group" "lambda_central" {
  name              = "/aws/lambda/${aws_lambda_function.central_logging_cross_account.function_name}"
  retention_in_days = 30
  tags              = "${local.tags}"
}
