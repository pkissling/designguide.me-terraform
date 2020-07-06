output "logging_policy_arn" {
  description = "ARN of the policy to log in Cloudwatch"
  value       = aws_iam_policy.logging.arn
}

output "send_email_policy_arn" {
  description = "ARN of the policy to send emails"
  value       = aws_iam_policy.send_emails.arn
}
