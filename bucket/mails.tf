# Contains incoming emails
resource "aws_s3_bucket" "incoming_mails" {
  bucket = "${var.domain}-incoming-mails"
  acl    = "private"

  # allow deletion of non-empty bucket
  force_destroy = true

  versioning {
    enabled = true
  }
}

# Access policy to allow SES to write incoming mails to bucket
resource "aws_s3_bucket_policy" "incoming_mails" {
  bucket = aws_s3_bucket.incoming_mails.id
  policy = data.aws_iam_policy_document.incoming_mails.json
}
data "aws_iam_policy_document" "incoming_mails" {
  statement {
    actions = ["s3:PutObject"]

    principals {
      type        = "Service"
      identifiers = ["ses.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:Referer"
      values   = [var.aws_account_id]
    }

    resources = ["${aws_s3_bucket.incoming_mails.arn}/*"]
  }
}
