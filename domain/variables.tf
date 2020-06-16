variable "domain" {
  description = "The site's domain"
  type        = string
}

variable "cdn_website_domain_name" {
  description = "Domain name of the website's CDN"
  type        = string
}

variable "cdn_website_hosted_zone_id" {
  description = "Hosted Zone ID of the website's CDN"
  type        = string
}

variable "certificate_validation_record_name" {
  description = "DNS record name to validate the certificate via DNS"
  type        = string
}

variable "certificate_validation_record_type" {
  description = "DNS record type to validate the certificate via DNS"
  type        = string
}

variable "certificate_validation_record_value" {
  description = "DNS record value to validate the certificate via DNS"
  type        = string
}

variable "mail_domain_validation_record_name" {
  description = "DNS record name to validate the email domain via DNS"
  type        = string
}

variable "mail_domain_validation_record_type" {
  description = "DNS record type to validate the email domain via DNS"
  type        = string
}

variable "mail_domain_validation_record_value" {
  description = "DNS record value to validate the email domain via DNS"
  type        = string
}
