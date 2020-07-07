variable "domain" {
  description = "The site's domain"
  type        = string
}

variable "bucket_functions_src_arn" {
  description = "ARN of the bucket containing lambda functions source code"
  type        = string
}

variable "bucket_functions_src_id" {
  description = "ID of the bucket containing lambda functions source code"
  type        = string
}

variable "policy_logging_arn" {
  description = "ARN of the policy to log in Cloudwatch"
  type        = string
}

variable "policy_send_email_arn" {
  description = "ARN of the policy to send emails"
  type        = string
}

variable "gateway_execution_arn" {
  description = "Execution ARN of the gateway"
  type        = string
}

variable "mail_messages_to" {
  description = "Recipient mail address when sending emails from Lambda"
  type        = string
}
