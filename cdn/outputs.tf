output "cdn_website_domain_name" {
  description = "Domain name of the website's CDN"
  value       = aws_cloudfront_distribution.website.domain_name
}

output "cdn_website_hosted_zone_id" {
  description = "Hosted zone id of the website's CDN"
  value       = aws_cloudfront_distribution.website.hosted_zone_id
}

output "cdn_website_iam_arn" {
  description = "ARN of the website's CDN IAM user"
  value       = aws_cloudfront_origin_access_identity.website.iam_arn
}

output "cdn_website_arn" {
  description = "ARN of the website's CDN"
  value       = aws_cloudfront_distribution.website.arn
}
