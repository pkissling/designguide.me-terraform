output "lambda_messages_invoke_arn" {
  description = "ARN to execute the Lambda function"
  value       = aws_lambda_function.messages_post.invoke_arn
}
