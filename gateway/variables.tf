variable "domain" {
  description = "The site's domain"
  type        = string
}

variable "lambda_messages_invoke_arn" {
  description = "Invoke ARN of /messages Lambda function"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the certificate"
  type        = string
}