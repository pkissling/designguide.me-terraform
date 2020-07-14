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

variable "bucket_incoming_mails_id" {
  description = "ID of the bucket containing incoming mails"
  type        = string
}

variable "bucket_incoming_mails_arn" {
  description = "ARN of the bucket containing incoming mails"
  type        = string
}

variable "policy_update_functions_arn" {
  description = "ARN of the policy to update lambda functions"
  type        = string
}

variable "policy_access_functions_source_code_bucket_arn" {
  description = "ARN of bucket where source code of other functions are stored"
  type        = string
}

variable "policy_access_incoming_mails_bucket_arn" {
  description = "ARN of policy to access bucket where incoming mails are stored"
  type        = string
}

variable "aws_account_id" {
  description = "The current AWS account ID"
  type        = string
}

variable "policy_access_attachments_bucket_arn" {
  description = "ARN of policy to access bucket where attachments are stored"
  type        = string
}