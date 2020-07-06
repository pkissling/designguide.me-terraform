locals {
  domain_name_lambda_regex = replace(var.domain, ".", "-")
}

# The actual function to update other functions on zip upload to S3
resource "aws_lambda_function" "deployer" {
  function_name = "${local.domain_name_lambda_regex}_function-deployer"
  role          = aws_iam_role.deployer.arn
  handler       = "deployer.handler"

  filename         = "./target/deployer.zip"
  source_code_hash = filebase64sha256("./target/deployer.zip")

  runtime = "nodejs12.x"
}

# Create role to allow deployer function to assume role
resource "aws_iam_role" "deployer" {
  name               = "${var.domain}-function_deployer"
  assume_role_policy = data.aws_iam_policy_document.deployer.json
}

data "aws_iam_policy_document" "deployer" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Allow exceution of function from S3 bucket
resource "aws_lambda_permission" "deployer" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.deployer.arn
  principal     = "s3.amazonaws.com"
  source_arn    = var.functions_src_bucket_arn
}

# Define events in S3 triggering the linked function
resource "aws_s3_bucket_notification" "deployer" {
  bucket = var.functions_src_bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.deployer.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

# Allow deployer function to update other functions
resource "aws_iam_policy" "update_functions" {
  name        = "${var.domain}-update_lambda_functions"
  path        = "/"
  description = "Update lambda functions"
  policy      = data.aws_iam_policy_document.update_functions.json
}
resource "aws_iam_role_policy_attachment" "update_functions" {
  role       = aws_iam_role.deployer.name
  policy_arn = aws_iam_policy.update_functions.arn
}
data "aws_iam_policy_document" "update_functions" {
  statement {
    actions = ["lambda:UpdateFunctionCode"]

    resources = [
      aws_lambda_function.messages_post.arn,
      aws_lambda_function.messages_options.arn
    ]
  }
}

# Allow deployer function to fetch functions source code from S3
resource "aws_iam_policy" "access_functions_source_code_bucket" {
  name        = "${var.domain}-access_functions_source_code_bucket"
  path        = "/"
  description = "Read from bucket where source code of other functions is stored."

  policy = data.aws_iam_policy_document.access_functions_source_code_bucket.json
}
resource "aws_iam_role_policy_attachment" "access_functions_source_code_bucket" {
  role       = aws_iam_role.deployer.name
  policy_arn = aws_iam_policy.access_functions_source_code_bucket.arn
}
data "aws_iam_policy_document" "access_functions_source_code_bucket" {
  statement {
    actions   = ["s3:Get*"]
    resources = ["${var.functions_src_bucket_arn}/*"]
  }
}

# Log function output to CloudWatch
resource "aws_cloudwatch_log_group" "deployer_logging" {
  name              = "/aws/lambda/${aws_lambda_function.deployer.function_name}"
  retention_in_days = 14
}
# Attach policy for Cloudwatch logging
resource "aws_iam_role_policy_attachment" "deployer_logs" {
  role       = aws_iam_role.deployer.name
  policy_arn = var.logging_policy_arn
}
