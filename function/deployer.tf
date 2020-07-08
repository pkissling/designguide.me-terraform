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
  source_arn    = var.bucket_functions_src_arn
}

# Define events in S3 triggering the linked function
resource "aws_s3_bucket_notification" "deployer" {
  bucket = var.bucket_functions_src_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.deployer.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

# Policy to update other functions
resource "aws_iam_role_policy_attachment" "deployer_update_functions" {
  role       = aws_iam_role.deployer.name
  policy_arn = var.policy_update_functions_arn
}

# Policy to access S3 bucket containing function's source code
resource "aws_iam_role_policy_attachment" "deployer_access_functions_source_code_bucket" {
  role       = aws_iam_role.deployer.name
  policy_arn = var.policy_access_functions_source_code_bucket_arn
}

# Policy for CloudWatch logging
resource "aws_iam_role_policy_attachment" "deployer_logging" {
  role       = aws_iam_role.deployer.name
  policy_arn = var.policy_logging_arn
}

# Log function output to CloudWatch
resource "aws_cloudwatch_log_group" "deployer_logging" {
  name              = "/aws/lambda/${aws_lambda_function.deployer.function_name}"
  retention_in_days = 14
}

