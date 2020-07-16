# Lambda function for POST /attachments
resource "aws_lambda_function" "attachments_post" {
  function_name = "${local.domain_name_lambda_regex}_attachments-post"
  role          = aws_iam_role.attachments_post.arn
  handler       = "attachments-post.handler"
  runtime       = "nodejs12.x"

  s3_bucket = var.bucket_functions_src_id
  s3_key    = "${local.domain_name_lambda_regex}_attachments-post.zip"

  environment {
    variables = {
      S3_BUCKET = var.bucket_attachments_id
    }
  }
}

# IAM policy for POST /attachments function
resource "aws_iam_role" "attachments_post" {
  name               = "${var.domain}-function_attachments_post"
  assume_role_policy = data.aws_iam_policy_document.attachments.json
}

# Allow gateway to invoke POST /attachments function
resource "aws_lambda_permission" "attachments_post" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.attachments_post.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.gateway_execution_arn}/*/*"
}

resource "aws_iam_role_policy_attachment" "attachments_post_access_attachments_bucket" {
  role       = aws_iam_role.attachments_post.name
  policy_arn = var.policy_access_attachments_bucket_arn
}

# Log function output to CloudWatch
resource "aws_cloudwatch_log_group" "attachments_post_logging" {
  name              = "/aws/lambda/${aws_lambda_function.attachments_post.function_name}"
  retention_in_days = 14
}
# Attach policy for Cloudwatch logging
resource "aws_iam_role_policy_attachment" "attachments_post_logging" {
  role       = aws_iam_role.attachments_post.name
  policy_arn = var.policy_logging_arn
}

# IAM Policy for both functions
data "aws_iam_policy_document" "attachments" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
