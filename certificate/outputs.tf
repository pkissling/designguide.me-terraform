output "certificate_validation_record_name" {
  description = "DNS record name to validate the certificate via DNS"
  value       = aws_acm_certificate.root.domain_validation_options.0.resource_record_name
}

output "certificate_validation_record_type" {
  description = "DNS record type to validate the certificate via DNS"
  value       = aws_acm_certificate.root.domain_validation_options.0.resource_record_type
}

output "certificate_validation_record_value" {
  description = "DNS record value to validate the certificate via DNS"
  value       = aws_acm_certificate.root.domain_validation_options.0.resource_record_value
}

output "certificate_arn" {
  description = "ARN of the certificate"
  value       = aws_acm_certificate_validation.root.certificate_arn
}