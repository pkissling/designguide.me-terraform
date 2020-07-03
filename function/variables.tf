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