# Permit read operations bucket contaning functions source code
resource "aws_iam_policy" "access_functions_source_code_bucket" {
  name        = "${var.domain}-access_functions_source_code_bucket"
  path        = "/"
  description = "Read from bucket where source code of other functions are stored."

  policy = data.aws_iam_policy_document.access_functions_source_code_bucket.json
}

data "aws_iam_policy_document" "access_functions_source_code_bucket" {
  statement {
    actions   = ["s3:Get*"]
    resources = ["${var.bucket_functions_src_arn}/*"]
  }
}

# Permit Lambda function to access attachments bucket
resource "aws_iam_policy" "access_attachments_bucket" {
  name        = "${var.domain}-access_attachments_bucket"
  path        = "/"
  description = "Access bucket where attachments are stored"

  policy = data.aws_iam_policy_document.access_attachments_bucket.json
}

data "aws_iam_policy_document" "access_attachments_bucket" {
  statement {
    actions   = ["s3:PutObject"]
    resources = ["${var.bucket_attachments_arn}/*"]
  }
}
