resource "aws_iam_policy" "send_emails" {
  name        = "${var.domain}-send_emails"
  path        = "/"
  description = "Send emails via SES"

  policy = data.aws_iam_policy_document.send_emails.json
}

data "aws_iam_policy_document" "send_emails" {
  statement {
    actions = ["ses:SendEmail"]

    resources = [
      var.mail_domain_identity_arn,
      var.mail_email_identity_arn
    ]
  }
}
