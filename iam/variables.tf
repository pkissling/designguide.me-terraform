variable "domain" {
  description = "The site's domain"
  type        = string
}

variable "website_bucket_arn" {
  description = "ARN of the website's bucket"
  type        = string
}

variable "website_cdn_arn" {
  description = "ARN of the website's CDN"
  type        = string
}

variable "functions_src_bucket_arn" {
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
