# The certificate
resource "aws_acm_certificate" "root" {
  domain_name               = var.domain
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domain}"]

  provider = aws.virginia
}

# This resource becomes available once the certificate was validated via DNS record in Route53
resource "aws_acm_certificate_validation" "root" {
  certificate_arn         = aws_acm_certificate.root.arn
  validation_record_fqdns = [aws_acm_certificate.root.domain_validation_options.0.resource_record_name]

  provider = aws.virginia
}

# Certificates are to be created in Virginia
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}
