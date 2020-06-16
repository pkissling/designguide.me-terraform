# Website deployment user
resource "aws_iam_user" "website_deployment_user" {
  name = "${var.domain}-website_deployment_user"
}

# Create access key to allow API access
resource "aws_iam_access_key" "website_deployment_user_access_key" {
  user = aws_iam_user.website_deployment_user.name
}


# Website deployment policy
resource "aws_iam_policy" "website_deployment_policy" {
  name   = "${var.domain}_website_deployment"
  description = "S3 sync & Cloudfront invalidation"
  policy = data.template_file.website_deployment_policy.rendered
}

# Link deployment user with policy
resource "aws_iam_user_policy_attachment" "website_deployment" {
  user       = aws_iam_user.website_deployment_user.name
  policy_arn = aws_iam_policy.website_deployment_policy.arn
}

# Load policy from file
data "template_file" "website_deployment_policy" {
  template = file("${path.module}/website_deployment_user_policy.json")

  vars = {
    website_bucket_arn = var.website_bucket_arn
    website_cdn_arn    = var.website_cdn_arn
  }
}
