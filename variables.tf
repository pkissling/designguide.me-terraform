variable "aws_region" {
  description = "The AWS region to create the resources in (Certificates will still be created in us-east-1)"
}

variable "domain" {
  description = "The site's domain"
}

variable "mail_messages_to" {
  description = "Recipient mail address when sending emails from Lambda"
  type        = string
}
