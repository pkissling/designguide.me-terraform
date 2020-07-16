# Lambda function for OPTIONS requests
resource "aws_lambda_function" "cors_options" {
  function_name = "${local.domain_name_lambda_regex}_cors-options"
  role          = aws_iam_role.cors_options.arn
  handler       = "cors-options.handler"
  runtime       = "nodejs12.x"

  s3_bucket = var.bucket_functions_src_id
  s3_key    = "${local.domain_name_lambda_regex}_cors-options.zip"
}

# IAM policy for CORS OPTIONS function
resource "aws_iam_role" "cors_options" {
  name               = "${var.domain}-function_cors_options"
  assume_role_policy = data.aws_iam_policy_document.cors_options.json
}

# Allow gateway to invoke CORS OPTIONS function
resource "aws_lambda_permission" "cors_options" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cors_options.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.gateway_execution_arn}/*/*"
}

# Log function output to CloudWatch
resource "aws_cloudwatch_log_group" "cors_options_logging" {
  name              = "/aws/lambda/${aws_lambda_function.cors_options.function_name}"
  retention_in_days = 14
}

# Attach policy for Cloudwatch logging
resource "aws_iam_role_policy_attachment" "cors_options_logging" {
  role       = aws_iam_role.cors_options.name
  policy_arn = var.policy_logging_arn
}

# IAM Policy for function
data "aws_iam_policy_document" "cors_options" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
