variable "domain" {
  description = "The site's domain"
  type        = string
}

variable "website_cdn_iam_arn" {
  description = "ARN of the website's CDN IAM user"
  type        = string
}
