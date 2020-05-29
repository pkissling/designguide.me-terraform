variable "domain" {
  description = "The site's domain"
  type        = string
}

variable "website_bucket_id" {
  description = "ID of the website's bucket"
  type        = string
}

variable "website_domain_name" {
  description = "Domain name of the website's bucket"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the certificate"
  type        = string
}