output "lambda_messages_post_invoke_arn" {
  description = "ARN to execute the POST /messages Lambda function"
  value       = aws_lambda_function.messages_post.invoke_arn
}

output "lambda_messages_options_invoke_arn" {
  description = "ARN to execute the OPTIONS /messages Lambda function"
  value       = aws_lambda_function.messages_options.invoke_arn
}

