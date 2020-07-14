# Contains the lambda functions source code
resource "aws_s3_bucket" "attachments" {
  bucket = "${var.domain}-attachments"
  acl    = "private"

  # allow deletion of non-empty bucket
  force_destroy = true

  versioning {
    enabled = true
  }
}
