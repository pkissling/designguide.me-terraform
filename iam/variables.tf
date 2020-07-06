variable "domain" {
  description = "The site's domain"
  type        = string
}

variable "bucket_website_arn" {
  description = "ARN of the website's bucket"
  type        = string
}

variable "cdn_website_arn" {
  description = "ARN of the website's CDN"
  type        = string
}

variable "bucket_functions_src_arn" {
  description = "ARN of the bucket containing lambda functions source code"
  type        = string
}

variable "mail_domain_identity_arn" {
  description = "ARN of the mail's domain identity"
  type        = string
}

variable "mail_email_identity_arn" {
  description = "ARN of the actual mail's email identity"
  type        = string
}
