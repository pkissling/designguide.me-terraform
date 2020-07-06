variable "domain" {
  description = "The site's domain"
  type        = string
}

variable "lambda_messages_options_invoke_arn" {
  description = "ARN to execute the OPTIONS /messages Lambda function"
  type        = string
}

variable "lambda_messages_post_invoke_arn" {
  description = "ARN to execute the POST /messages Lambda function"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the certificate"
  type        = string
}

variable "logging_policy_arn" {
  description = "ARN of the policy to log in Cloudwatch"
  type        = string
}
