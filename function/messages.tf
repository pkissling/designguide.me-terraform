# Lambda function for POST /messages
resource "aws_lambda_function" "messages_post" {
  function_name = "${local.domain_name_lambda_regex}_messages-post"
  role          = aws_iam_role.messages_post.arn
  handler       = "messages-post.handler"
  runtime       = "nodejs12.x"

  s3_bucket = var.bucket_functions_src_id
  s3_key    = "${local.domain_name_lambda_regex}_messages-post.zip"

  environment {
    variables = {
      TO_MAIL   = var.mail_messages_to
      FROM_MAIL = "mailer@${var.domain}"
    }
  }
}

# IAM policy for POST /messages function
resource "aws_iam_role" "messages_post" {
  name               = "${var.domain}-function_messages_post"
  assume_role_policy = data.aws_iam_policy_document.messages_post.json
}

# Allow gateway to invoke POST /messages function
resource "aws_lambda_permission" "messages_post" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.messages_post.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.gateway_execution_arn}/*/*"
}

# Log function output to CloudWatch
resource "aws_cloudwatch_log_group" "messages_post_logging" {
  name              = "/aws/lambda/${aws_lambda_function.messages_post.function_name}"
  retention_in_days = 14
}
# Attach policy for Cloudwatch logging
resource "aws_iam_role_policy_attachment" "messages_post_logging" {
  role       = aws_iam_role.messages_post.name
  policy_arn = var.policy_logging_arn
}

# Allow POST /messages to send emails
resource "aws_iam_role_policy_attachment" "messages_post_send_emails" {
  role       = aws_iam_role.messages_post.name
  policy_arn = var.policy_send_email_arn
}

# IAM Policy for function
data "aws_iam_policy_document" "messages_post" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
