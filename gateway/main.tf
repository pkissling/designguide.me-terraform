# REST API
resource "aws_api_gateway_rest_api" "root" {
  name        = "api.${var.domain}"
  description = "${var.domain} API"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

# API settings
# Enable throttling and logging
resource "aws_api_gateway_method_settings" "settings" {
  rest_api_id = aws_api_gateway_rest_api.root.id
  stage_name  = aws_api_gateway_deployment.v1.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled    = true
    data_trace_enabled = true
    logging_level      = "INFO"

    throttling_rate_limit  = 100
    throttling_burst_limit = 50
  }
}

# Resource /messages
resource "aws_api_gateway_resource" "messages" {
  rest_api_id = aws_api_gateway_rest_api.root.id
  parent_id   = aws_api_gateway_rest_api.root.root_resource_id
  path_part   = "messages"
}

# Resource /attachments
resource "aws_api_gateway_resource" "attachments" {
  rest_api_id = aws_api_gateway_rest_api.root.id
  parent_id   = aws_api_gateway_rest_api.root.root_resource_id
  path_part   = "attachments"
}

# POST /messages
resource "aws_api_gateway_method" "messages_post" {
  rest_api_id   = aws_api_gateway_rest_api.root.id
  resource_id   = aws_api_gateway_resource.messages.id
  http_method   = "POST"
  authorization = "NONE"
}

# OPTIONS /messages
resource "aws_api_gateway_method" "messages_options" {
  rest_api_id   = aws_api_gateway_rest_api.root.id
  resource_id   = aws_api_gateway_resource.messages.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# POST /messages
resource "aws_api_gateway_method" "attachments_post" {
  rest_api_id   = aws_api_gateway_rest_api.root.id
  resource_id   = aws_api_gateway_resource.attachments.id
  http_method   = "POST"
  authorization = "NONE"
}

# Link between POST /messages and lambda function
resource "aws_api_gateway_integration" "messages_post" {
  rest_api_id = aws_api_gateway_rest_api.root.id
  resource_id = aws_api_gateway_method.messages_post.resource_id
  http_method = aws_api_gateway_method.messages_post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_messages_post_invoke_arn
}

# Link between OPTIONS /messages and lambda function
resource "aws_api_gateway_integration" "messages_options" {
  rest_api_id = aws_api_gateway_rest_api.root.id
  resource_id = aws_api_gateway_method.messages_options.resource_id
  http_method = aws_api_gateway_method.messages_options.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_messages_options_invoke_arn
}

# Link between POST /attachments and lambda function
resource "aws_api_gateway_integration" "attachments_post" {
  rest_api_id = aws_api_gateway_rest_api.root.id
  resource_id = aws_api_gateway_method.attachments_post.resource_id
  http_method = aws_api_gateway_method.attachments_post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_attachments_post_invoke_arn
}

# API stage v1
resource "aws_api_gateway_deployment" "v1" {
  triggers = {
    redeployment = sha1(join(",", list(
      jsonencode(aws_api_gateway_integration.messages_post),
      jsonencode(aws_api_gateway_integration.messages_options),
      jsonencode(aws_api_gateway_integration.attachments_post),
    )))
  }

  rest_api_id = aws_api_gateway_rest_api.root.id
  stage_name  = "v1"

  lifecycle {
    create_before_destroy = true
  }
}

# Custom domain name for subdomain api.[...]
resource "aws_api_gateway_domain_name" "api" {
  domain_name     = "api.${var.domain}"
  certificate_arn = var.certificate_arn

  endpoint_configuration {
    types = ["EDGE"]
  }
}

# Link between custom domain name and API
resource "aws_api_gateway_base_path_mapping" "v1" {
  api_id      = aws_api_gateway_rest_api.root.id
  domain_name = aws_api_gateway_domain_name.api.domain_name
  stage_name  = aws_api_gateway_deployment.v1.stage_name
  base_path   = aws_api_gateway_deployment.v1.stage_name
}

# Allow cloudwatch logging
resource "aws_api_gateway_account" "root" {
  cloudwatch_role_arn = aws_iam_role.root.arn
}

# IAM role of the API
resource "aws_iam_role" "root" {
  name               = "${var.domain}-api_gateway"
  assume_role_policy = data.aws_iam_policy_document.root.json
}
data "aws_iam_policy_document" "root" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

# Attach policy for Cloudwatch logging
resource "aws_iam_role_policy_attachment" "logging" {
  role       = aws_iam_role.root.name
  policy_arn = var.policy_logging_arn
}
