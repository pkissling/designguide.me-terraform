output "policy_logging_arn" {
  description = "ARN of the policy to log in Cloudwatch"
  value       = aws_iam_policy.logging.arn
}

output "policy_send_email_arn" {
  description = "ARN of the policy to send emails"
  value       = aws_iam_policy.send_emails.arn
}

output "policy_update_functions_arn" {
  description = "ARN of the policy to update lambda functions"
  value       = aws_iam_policy.update_functions.arn
}

output "policy_access_functions_source_code_bucket_arn" {
  description = "ARN of policy to access bucket where source code of other functions are stored"
  value       = aws_iam_policy.access_functions_source_code_bucket.arn
}

output "policy_access_incoming_mails_bucket_arn" {
  description = "ARN of policy to access bucket where incoming mails are stored"
  value       = aws_iam_policy.access_incoming_mails_bucket.arn
}

output "policy_access_attachments_bucket_arn" {
  description = "ARN of policy to access bucket where attachments are stored"
  value       = aws_iam_policy.access_attachments_bucket.arn
}
