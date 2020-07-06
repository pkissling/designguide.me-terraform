output "policy_logging_arn" {
  description = "ARN of the policy to log in Cloudwatch"
  value       = aws_iam_policy.logging.arn
}

output "policy_send_email_arn" {
  description = "ARN of the policy to send emails"
  value       = aws_iam_policy.send_emails.arn
}
