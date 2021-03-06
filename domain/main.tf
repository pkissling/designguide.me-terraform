# The actual route53 zone
resource "aws_route53_zone" "root" {
  name          = var.domain
  force_destroy = true
}

# Root record
resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.root.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = var.cdn_website_domain_name
    zone_id                = var.cdn_website_hosted_zone_id
    evaluate_target_health = false
  }
}

# Subdomain record www.[...]
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.root.zone_id
  name    = "www.${var.domain}"
  type    = "A"

  alias {
    name                   = var.cdn_website_domain_name
    zone_id                = var.cdn_website_hosted_zone_id
    evaluate_target_health = false
  }
}

# Subdomain record api.[...]
resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.root.zone_id
  name    = "api.${var.domain}"
  type    = "A"

  alias {
    name                   = var.cdn_api_domain_name
    zone_id                = var.cdn_api_hosted_zone_id
    evaluate_target_health = true
  }
}

# Record for cerificate validation
resource "aws_route53_record" "certificate_validation" {
  zone_id = aws_route53_zone.root.zone_id
  name    = var.certificate_validation_record_name
  type    = var.certificate_validation_record_type
  records = [var.certificate_validation_record_value]
  ttl     = 60
}

# Record for email identity validation
resource "aws_route53_record" "mail_identity_validation" {
  zone_id = aws_route53_zone.root.zone_id
  name    = var.mail_domain_validation_record_name
  type    = var.mail_domain_validation_record_type
  records = [var.mail_domain_validation_record_value]
  ttl     = 60
}

# Record to allow receiving mails
resource "aws_route53_record" "mail_receiver_validation" {
  zone_id = aws_route53_zone.root.zone_id
  name    = var.domain
  type    = "MX"
  ttl     = "300"
  records = ["10 inbound-smtp.eu-west-1.amazonaws.com"] # Static value
}

# https://github.com/terraform-providers/terraform-provider-aws/issues/88
# Workaround to manipulate domain nameservers after creation of zone
resource "null_resource" "update_domains" {
  provisioner "local-exec" {
    command = "aws route53domains update-domain-nameservers --region us-east-1 --domain-name ${var.domain} --nameservers Name=${aws_route53_zone.root.name_servers.0} Name=${aws_route53_zone.root.name_servers.1} Name=${aws_route53_zone.root.name_servers.2} Name=${aws_route53_zone.root.name_servers.3}"
  }
}
