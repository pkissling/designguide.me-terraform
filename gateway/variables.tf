variable "domain" {
  description = "The site's domain"
  type        = string
}

variable "lambda_cors_options_invoke_arn" {
  description = "ARN to execute the CORS OPTIONS Lambda function"
  type        = string
}

variable "lambda_messages_post_invoke_arn" {
  description = "ARN to execute the POST /messages Lambda function"
  type        = string
}

variable "lambda_attachments_post_invoke_arn" {
  description = "ARN to execute the POST /attachments Lambda function"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the certificate"
  type        = string
}

variable "policy_logging_arn" {
  description = "ARN of the policy to log in Cloudwatch"
  type        = string
}
