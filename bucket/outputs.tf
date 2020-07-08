output "bucket_website_id" {
  description = "ID of the website's bucket"
  value       = aws_s3_bucket.website.id
}

output "bucket_website_domain_name" {
  description = "Domain name of the website's bucket"
  value       = aws_s3_bucket.website.bucket_regional_domain_name
}

output "bucket_website_arn" {
  description = "ARN of the website's bucket"
  value       = aws_s3_bucket.website.arn
}

output "bucket_functions_src_id" {
  description = "ID of the bucket containing lambda functions source code"
  value       = aws_s3_bucket.functions_src.id
}

output "bucket_functions_src_arn" {
  description = "ARN of the bucket containing lambda functions source code"
  value       = aws_s3_bucket.functions_src.arn
}

output "bucket_incoming_mails_id" {
  description = "ID of the bucket containing incoming mails"
  value       = aws_s3_bucket.incoming_mails.id
}

output "bucket_incoming_mails_arn" {
  description = "ARN of the bucket containing incoming mails"
  value       = aws_s3_bucket.incoming_mails.arn
}
