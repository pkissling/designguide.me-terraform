output "lambda_messages_post_invoke_arn" {
  description = "ARN to invoke POST /messages Lambda function"
  value       = aws_lambda_function.messages_post.invoke_arn
}

output "lambda_messages_post_arn" {
  description = "ARN of POST /messages Lambda function"
  value       = aws_lambda_function.messages_post.arn
}

output "lambda_messages_options_invoke_arn" {
  description = "ARN to invoke OPTIONS /messages Lambda function"
  value       = aws_lambda_function.messages_options.invoke_arn
}

output "lambda_messages_options_arn" {
  description = "ARN of OPTIONS /messages Lambda function"
  value       = aws_lambda_function.messages_options.arn
}

output "lambda_mail_forwarder_arn" {
  description = "ARN of Lambda function to forward mails"
  value       = aws_lambda_function.mail_forwarder.arn
}

output "lambda_attachments_post_arn" {
  description = "ARN of POST /attachments Lambda function"
  value       = aws_lambda_function.attachments_post.arn
}

output "lambda_attachments_post_invoke_arn" {
  description = "ARN to invoke POST /attachments Lambda function"
  value       = aws_lambda_function.attachments_post.invoke_arn
}