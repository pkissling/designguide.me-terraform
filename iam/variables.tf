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
