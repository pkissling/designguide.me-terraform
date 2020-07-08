# Website deployment user
resource "aws_iam_user" "website_deployment_user" {
  name = "${var.domain}-website_deployment_user"
}

# Create access key to allow API access
resource "aws_iam_access_key" "website_deployment_user_access_key" {
  user = aws_iam_user.website_deployment_user.name
}

# Website deployment policy
resource "aws_iam_policy" "website_deployment" {
  name        = "${var.domain}-website_deployment"
  description = "S3 sync on website bucket & website Cloudfront invalidation"
  policy      = data.template_file.website_deployment.rendered
}

# Link deployment user with policy
resource "aws_iam_user_policy_attachment" "website_deployment" {
  user       = aws_iam_user.website_deployment_user.name
  policy_arn = aws_iam_policy.website_deployment.arn
}

# Load policy from file
data "template_file" "website_deployment" {
  template = file("${path.module}/website_deployment_user_policy.json")

  vars = {
    bucket_website_arn = var.bucket_website_arn
    cdn_website_arn    = var.cdn_website_arn
  }
}
