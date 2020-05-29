output "mail_domain_validation_record_name" {
  description = "DNS record name to validate the email domain via DNS"
  value       = "_amazonses.${var.domain}" # Value is static. No variable to lookup available!
}

output "mail_domain_validation_record_type" {
  description = "DNS record type to validate the email domain via DNS"
  value       = "TXT" # Value is static. No variable to lookup available!
}

output "mail_domain_validation_record_value" {
  description = "DNS record value to validate the email domain via DNS"
  value       = aws_ses_domain_identity.root.verification_token
}
