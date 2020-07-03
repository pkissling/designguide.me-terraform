# Contains the lambda functions source code
resource "aws_s3_bucket" "functions_src" {
  bucket = "${var.domain}-functions-src"
  acl    = "private" # only grant read access to CDN (see aws_s3_bucket_policy.website_policy)

  # allow deletion of non-empty bucket
  force_destroy = true

  versioning {
    enabled = true
  }
}
