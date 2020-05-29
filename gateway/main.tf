# REST API
resource "aws_api_gateway_rest_api" "root" {
  name        = "api.${var.domain}"
  description = "${var.domain} API"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

# Resource /messages
resource "aws_api_gateway_resource" "messages" {
  rest_api_id = aws_api_gateway_rest_api.root.id
  parent_id   = aws_api_gateway_rest_api.root.root_resource_id
  path_part   = "messages"
}

# POST /messages
resource "aws_api_gateway_method" "messages_post" {
  rest_api_id   = aws_api_gateway_rest_api.root.id
  resource_id   = aws_api_gateway_resource.messages.id
  http_method   = "POST"
  authorization = "NONE"
}

# Link between POST /messages and lambda function
resource "aws_api_gateway_integration" "messages_lambda" {
  rest_api_id = aws_api_gateway_rest_api.root.id
  resource_id = aws_api_gateway_method.messages_post.resource_id
  http_method = aws_api_gateway_method.messages_post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_messages_invoke_arn
}

# API stage v1
resource "aws_api_gateway_deployment" "v1" {
  depends_on = [aws_api_gateway_integration.messages_lambda]

  rest_api_id = aws_api_gateway_rest_api.root.id
  stage_name  = "v1"
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