output "website_bucket_id" {
  description = "ID of the website's bucket"
  value       = aws_s3_bucket.website.id
}

output "website_domain_name" {
  description = "Domain name of the website's bucket"
  value       = aws_s3_bucket.website.bucket_regional_domain_name
}

output "website_bucket_arn" {
  description = "ARN of the website's bucket"
  value       = aws_s3_bucket.website.arn
}

output "functions_src_bucket_id" {
  description = "ID of the bucket containing lambda functions source code"
  value       = aws_s3_bucket.functions_src.id
}

output "functions_src_bucket_arn" {
  description = "ARN of the bucket containing lambda functions source code"
  value       = aws_s3_bucket.functions_src.arn
}