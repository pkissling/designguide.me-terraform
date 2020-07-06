output "gateway_execution_arn" {
  description = "Execution ARN of the gateway"
  value       = aws_api_gateway_rest_api.root.execution_arn
}

output "cdn_api_hosted_zone_id" {
  description = "Hosted Zone ID of the API's CDN"
  value       = aws_api_gateway_domain_name.api.cloudfront_zone_id
}

output "cdn_api_domain_name" {
  description = "Domain name of the API's CDN"
  value       = aws_api_gateway_domain_name.api.cloudfront_domain_name
}
