# Root Domain identity
resource "aws_ses_domain_identity" "root" {
  domain = var.domain
}

# This resource becomes available once the domain was validated via DNS record in Route53
resource "aws_ses_domain_identity_verification" "root" {
  domain = aws_ses_domain_identity.root.id
}

resource "aws_ses_email_identity" "recipient" {
  email = var.mail_messages_to
}

