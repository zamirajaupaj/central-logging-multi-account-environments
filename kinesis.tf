resource "aws_kinesis_stream" "central_logging_cross_account" {
  name             = "${local.kinesis_name}"
  shard_count      = 1
  retention_period = 48
  tags             = "${local.tags}"
}

resource "aws_kinesis_firehose_delivery_stream" "central_logging_cross_account" {
  name        = "${local.kinesis_name}"
  destination = "elasticsearch"

  kinesis_source_configuration {
    kinesis_stream_arn = "${aws_kinesis_stream.central_logging_cross_account.arn}"
    role_arn           = "${aws_iam_role.central_logging_cross_account.arn}"
  }

  s3_configuration {
    role_arn           = "${aws_iam_role.central_logging_cross_account.arn}"
    bucket_arn         = "${aws_s3_bucket.central-logging-eu-west-1-today.arn}"
    compression_format = "GZIP"
    buffer_size        = 5
    buffer_interval    = 60
  }

  elasticsearch_configuration {
    domain_arn = "${aws_elasticsearch_domain.central_logging_cross_account.arn}"
    role_arn   = "${aws_iam_role.central_logging_cross_account.arn}"
    index_name = "central_logging_cross_account"
    type_name  = "central_logging_cross_account"

    processing_configuration {
      enabled = "true"

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "${aws_lambda_function.central_logging_cross_account.arn}:$LATEST"
        }
      }
    }

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "${aws_cloudwatch_log_group.firehose_central_logging_cross_account.name}"
      log_stream_name = "S3Delivery"
    }
  }

  tags = "${local.tags}"
}

resource "aws_cloudwatch_log_group" "firehose_central_logging_cross_account" {
  name              = "/aws/kinesisfirehose/${local.kinesis_name}"
  retention_in_days = 30
  tags              = "${local.tags}"
}
