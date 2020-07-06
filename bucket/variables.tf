variable "domain" {
  description = "The site's domain"
  type        = string
}

variable "aws_account_id" {
  description = "The current AWS account ID"
  type        = string
}

variable "cdn_website_iam_arn" {
  description = "ARN of the website's CDN IAM user"
  type        = string
}
