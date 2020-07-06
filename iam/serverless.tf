# Serverless deployment user
resource "aws_iam_user" "serverless_deployment_user" {
  name = "${var.domain}-serverless_deployment_user"
}

# Create access key to allow API access
resource "aws_iam_access_key" "serverless_deployment_user_access_key" {
  user = aws_iam_user.serverless_deployment_user.name
}

# Serverless deployment policy
resource "aws_iam_policy" "serverless_deployment_policy" {
  name        = "${var.domain}-serverless_deployment"
  description = "S3 sync on functions-src bucket"
  policy      = data.aws_iam_policy_document.serverless_deployment_policy.json
}

# Link deployment user with policy
resource "aws_iam_user_policy_attachment" "serverless_deployment" {
  user       = aws_iam_user.serverless_deployment_user.name
  policy_arn = aws_iam_policy.serverless_deployment_policy.arn
}

data "aws_iam_policy_document" "serverless_deployment_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]

    resources = [
      "${var.bucket_functions_src_arn}",
      "${var.bucket_functions_src_arn}/*"
    ]
  }
}
