# Permitr read operations bucket contaning functions source code
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
