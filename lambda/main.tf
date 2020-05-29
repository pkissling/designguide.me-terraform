locals {
  domain_name_lambda_regex = replace(var.domain, ".", "-")
}

# Lambda function for /messages
resource "aws_lambda_function" "messages_post" {
  function_name = "${local.domain_name_lambda_regex}_messages_post"
  role          = aws_iam_role.messages.arn
  handler       = "index.handler"

  filename         = "../backend/contact_form.zip"
  source_code_hash = filebase64sha256("../backend/contact_form.zip")

  runtime = "nodejs12.x"
}

# IAM policy for /messages function
resource "aws_iam_role" "messages" {
  assume_role_policy = data.template_file.lambda_messages_post_policy.rendered
}

# Allow gateway to invoke function
resource "aws_lambda_permission" "messages_post" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.messages_post.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.gateway_execution_arn}/*/*"
}

# Load policy from file
data "template_file" "lambda_messages_post_policy" {
  template = file("${path.module}/messages_post_policy.json")
}
