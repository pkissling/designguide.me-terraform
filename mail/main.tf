# Root Domain identity
resource "aws_ses_domain_identity" "root" {
  domain = var.domain
}

# This resource becomes available once the domain was validated via DNS record in Route53
resource "aws_ses_domain_identity_verification" "root" {
  domain = aws_ses_domain_identity.root.id
}

# Recipient email address
resource "aws_ses_email_identity" "recipient" {
  email = var.mail_messages_to
}

# Default ruleset applied to incoming mails
resource "aws_ses_receipt_rule_set" "default" {
  rule_set_name = "default"
}

# Make default ruleset active
resource "aws_ses_active_receipt_rule_set" "default" {
  rule_set_name = aws_ses_receipt_rule_set.default.id
}

# Write incoming mails to s3
resource "aws_ses_receipt_rule" "forward_mails" {
  name          = "${var.domain}-forward_mails"
  rule_set_name = aws_ses_active_receipt_rule_set.default.id
  recipients    = [var.domain]
  enabled       = true
  scan_enabled  = true

  s3_action {
    bucket_name = var.bucket_incoming_mails_id
    position    = 1
  }

  lambda_action {
    function_arn    = var.lambda_mail_forwarder_arn
    invocation_type = "Event"
    position        = 2
  }

}
