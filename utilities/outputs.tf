# data object to retrieve the current AWS context
data "aws_caller_identity" "current" {
  # no arguments
}

output "aws_account_id" {
  description = "The current AWS account ID"
  value       = data.aws_caller_identity.current.account_id
}
