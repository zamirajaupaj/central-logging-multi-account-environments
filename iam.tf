resource "aws_iam_role" "central_logging_cross_account" {
  name               = "central-logging"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_central_logging_cross_account.json}"
}

data "aws_iam_policy_document" "assume_role_central_logging_cross_account" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "central_logging_cross_account" {
  name   = "central-logging"
  role   = "${aws_iam_role.central_logging_cross_account.id}"
  policy = "${data.aws_iam_policy_document.policy_central_logging_cross_account.json}"
}

data "aws_iam_policy_document" "policy_central_logging_cross_account" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetBucketLocation",
      "s3:AbortMultipartUpload",
    ]

    resources = [
      "${aws_s3_bucket.central-logging-eu-west-1-today.arn}",
      "${aws_s3_bucket.central-logging-eu-west-1-today.arn}/*",
    ]
  }

  statement {
    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
      "kinesis:ListStreams",
    ]

    resources = [
      "${aws_kinesis_stream.central_logging_cross_account.arn}",
    ]
  }

  statement {
    actions = [
      "lambda:InvokeFunction",
      "lambda:GetFunctionConfiguration",
    ]

    resources = [
      "${aws_lambda_function.central_logging_cross_account.arn}:*",
    ]
  }

  statement {
    actions = [
      "es:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
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
      "logs:*",
      "kinesis:*",
      "firehose:*",
    ]

    resources = [
      "*",
    ]
  }
}
