# Send mail policy
resource "aws_iam_policy" "send_emails" {
  name        = "${var.domain}-send_emails"
  path        = "/"
  description = "Send emails via SES"

  policy = data.aws_iam_policy_document.send_emails.json
}

data "aws_iam_policy_document" "send_emails" {
  statement {
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail"
    ]

    resources = [
      var.mail_domain_identity_arn,
      var.mail_email_identity_arn
    ]
  }
}

# Access incoming mails bucket policy
resource "aws_iam_policy" "access_incoming_mails_bucket" {
  name        = "${var.domain}-access-bucket"
  path        = "/"
  description = "Access incoming mails bucket"
  policy      = data.aws_iam_policy_document.access_incoming_mails_bucket.json
}

data "aws_iam_policy_document" "access_incoming_mails_bucket" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = ["${var.bucket_incoming_mails_arn}/*"]
  }
}
