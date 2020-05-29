output "website_bucket_id" {
  description = "ID of the website's bucket"
  value       = aws_s3_bucket.website.id
}

output "website_domain_name" {
  description = "Domain name of the website's bucket"
  value       = aws_s3_bucket.website.bucket_regional_domain_name
}

