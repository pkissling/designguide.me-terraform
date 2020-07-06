variable "domain" {
  description = "The site's domain"
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
