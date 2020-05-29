# Contains the website's assets
resource "aws_s3_bucket" "website" {
  bucket = var.domain
  acl    = "private" # only grant read access to CDN (see aws_s3_bucket_policy.website_policy)

  # allow deletion of non-empty bucket
  force_destroy = true

  logging {
    target_bucket = aws_s3_bucket.website_logs.bucket
  }

  versioning {
    enabled = true
  }

  website {
    index_document = "index.html"
  }
}

# Contains the access logs
resource "aws_s3_bucket" "website_logs" {
  bucket = "${var.domain}-logs"
  acl    = "log-delivery-write"

  # allow deletion of non-empty bucket
  force_destroy = true
}

# Access policy for public website access
resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website.id
  policy = data.template_file.website_policy.rendered
}

# Load policy from file
data "template_file" "website_policy" {
  template = file("${path.module}/website_policy.json")

  vars = {
    bucket_arn = aws_s3_bucket.website.arn
    cdn_arn    = var.cdn_arn
  }
}