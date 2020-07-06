# SES recieving is only availabe in Ireland
provider "aws" {
  region = "eu-west-1"
  alias  = "ireland"
}

# Root Domain identity
resource "aws_ses_domain_identity" "root" {
  provider = aws.ireland
  domain   = var.domain
}

# This resource becomes available once the domain was validated via DNS record in Route53
resource "aws_ses_domain_identity_verification" "root" {
  provider = aws.ireland
  domain   = aws_ses_domain_identity.root.id
}

# Recipient email address
resource "aws_ses_email_identity" "recipient" {
  provider = aws.ireland
  email    = var.mail_messages_to
}

# Default ruleset applied to incoming mails
resource "aws_ses_receipt_rule_set" "default" {
  provider      = aws.ireland
  rule_set_name = "default"
}

# Make default ruleset active
resource "aws_ses_active_receipt_rule_set" "default" {
  provider      = aws.ireland
  rule_set_name = aws_ses_receipt_rule_set.default.id
}

# Write incoming mails to s3
resource "aws_ses_receipt_rule" "mail_to_s3" {
  provider = aws.ireland

  name          = "${var.domain}-mail_to_s3"
  rule_set_name = aws_ses_active_receipt_rule_set.default.id
  recipients    = [var.domain]
  enabled       = true
  scan_enabled  = true

  s3_action {
    bucket_name = var.bucket_incoming_mails_id
    position    = 1
  }
}
