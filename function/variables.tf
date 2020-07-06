variable "domain" {
  description = "The site's domain"
  type        = string
}

variable "functions_src_bucket_arn" {
  description = "ARN of the bucket containing lambda functions source code"
  type        = string
}

variable "functions_src_bucket_id" {
  description = "ID of the bucket containing lambda functions source code"
  type        = string
}

variable "logging_policy_arn" {
  description = "ARN of the policy to log in Cloudwatch"
  type        = string
}

variable "gateway_execution_arn" {
  description = "Execution ARN of the gateway"
  type        = string
}

variable "send_email_policy_arn" {
  description = "ARN of the policy to send emails"
  type        = string
}

variable "mail_messages_from" {
  description = "Sender mail address when sending emails from Lambda"
  type        = string
}

variable "mail_messages_to" {
  description = "Recipient mail address when sending emails from Lambda"
  type        = string
}
