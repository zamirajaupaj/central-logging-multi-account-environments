resource "aws_elasticsearch_domain" "central_logging_cross_account" {
  domain_name           = "central-logging"
  elasticsearch_version = "6.5"

  log_publishing_options {
    cloudwatch_log_group_arn = "${aws_cloudwatch_log_group.central_logging_cross_account_els.arn}"
    log_type                 = "INDEX_SLOW_LOGS"
  }

  cluster_config {
    instance_type = "r5.large.elasticsearch"
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = 20
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  access_policies = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "es:*",
      "Principal": "*",
      "Effect": "Allow",
      "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/central-logging/*"
    }
  ]
}
POLICY

  tags = {
    Domain = "central_logging_cross_account"
  }
}

resource "aws_cloudwatch_log_group" "central_logging_cross_account_els" {
  name = "central_logging_cross_account_els"
}

resource "aws_cloudwatch_log_resource_policy" "central_logging_cross_account_els" {
  policy_name = "central_logging_cross_account_els"

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG
}
