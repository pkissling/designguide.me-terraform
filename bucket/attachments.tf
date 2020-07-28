# Contains the lambda functions source code
resource "aws_s3_bucket" "attachments" {
  bucket = "${var.domain}-attachments"
  acl    = "private"

  cors_rule {
    allowed_headers = ["Content-Type"]
    allowed_methods = ["PUT"]
    allowed_origins = [
      "https://${var.domain}",
      "https://www.${var.domain}",
      "http://localhost:8080"
    ]
    max_age_seconds = 3000

  }
  # allow deletion of non-empty bucket
  force_destroy = true

  versioning {
    enabled = true
  }
}
