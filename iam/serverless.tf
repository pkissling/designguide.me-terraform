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
  name   = "${var.domain}_serverless_deployment"
  description = "S3 sync & Cloudfront invalidation"
  policy = data.template_file.serverless_deployment_policy.rendered
}

# Link deployment user with policy
resource "aws_iam_user_policy_attachment" "serverless_deployment" {
  user       = aws_iam_user.serverless_deployment_user.name
  policy_arn = aws_iam_policy.serverless_deployment_policy.arn
}

# Load policy from file
data "template_file" "serverless_deployment_policy" {
  template = file("${path.module}/serverless_deployment_user_policy.json")
}
