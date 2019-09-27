data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "central-logging-eu-west-1-today" {
  force_destroy = true
  bucket        = "central-logging-${data.aws_region.current.name}-today-poland"
  acl           = "private"
  region        = "${data.aws_region.current.name}"

  versioning {
    enabled = true
  }

  tags = "${local.tags}"
}
