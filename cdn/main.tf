resource "aws_cloudfront_distribution" "website" {

  origin {
    origin_id   = var.website_bucket_id
    domain_name = var.website_domain_name
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.website.cloudfront_access_identity_path
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  price_class     = "PriceClass_100" # Edge optimized in Canada, US & Europe
  http_version    = "http2"

  default_root_object = "index.html"
  aliases = [
    var.domain,
    "www.${var.domain}"
  ]

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "DELETE", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    target_origin_id       = var.website_bucket_id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
}

# Access identity of the CDN (to access the website's bucket)
resource "aws_cloudfront_origin_access_identity" "website" {
}
