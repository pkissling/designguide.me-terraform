# [designguide.me](https://designguide.me)-terraform
[![Build Status](https://travis-ci.org/pkissling/designguide.me-terraform.svg?branch=master)](https://travis-ci.org/pkissling/designguide.me-terraform)

## Overview
[Terraform](https://www.terraform.io/) project to setup required AWS infrastructure for [designguide.me](https://designguide.me), which contains:
- S3 bucket for static website hosting
- Cloudfront distribution to serve website
- ACM certificate to serve traffic via https
- AWS Lambda as the backend
- API Gateway to consolidate and expose Lambda functions
- Route53 hosted zone for domain and `api.` subdomain
- SES mail server to send and receive mails

## Prerequisites

### Registered domain in AWS Route53

  The domain to be used must be registered in your AWS account.

### AWS access

  AWS Credentials with sufficient permission must be [setup](https://www.terraform.io/docs/providers/aws/index.html#authentication).

### Terraform backend

  Terraform uses an S3 bucket and a DynamoDB table to sync and store the `terraform.state` file. The required resources can be created with command:

  ```
  $ make state
  ```

## Installation

  ```
  $ make
  ```

## Modules

### S3 `module.bucket`

| Terraform resource type | Terraform resource name | Description                            |
| ----------------------- | ----------------------- | -------------------------------------- |
| `aws_s3_bucket`         | `functions_src`         | Stores source code of lambda functions |
| `aws_s3_bucket`         | `website`               | Website static content                 |
| `aws_s3_bucket`         | `website_logs`          | Website access logs                    |

### Cloudfront `module.cdn`

| Terraform resource type       | Terraform resource name | Description          |
| ----------------------------- | ----------------------- | -------------------- |
| `aws_cloudfront_distribution` | `website`               | CDN to serve website |

### Certificate Manager `module.certificate`

| Terraform resource type          | Terraform resource name | Description                                    |
| -------------------------------- | ----------------------- | ---------------------------------------------- |
| `aws_acm_certificate`            | `root`                  | Certificate `designguide.me`                   |
| `aws_acm_certificate_validation` | `root`                  | Certificate validation object `designguide.me` |

### Route53 `module.domain`

| Terraform resource type | Terraform resource name  | Description                                                        |
| ----------------------- | ------------------------ | ------------------------------------------------------------------ |
| `aws_route53_zone`      | `root`                   | Hosted zone `designguide.me`                                       |
| `aws_route53_record`    | `root`                   | DNS record `designguide.me`                                        |
| `aws_route53_record`    | `www`                    | DNS record `www.designguide.me`                                    |
| `aws_route53_record`    | `api`                    | DNS record `api.designguide.me`                                    |
| `aws_route53_record`    | `certificate_validation` | DNS record to validate certificate `aws_acm_certificate.root`      |
| `aws_route53_record`    | `mail_domain_validation` | DNS record to validate email domain `aws_ses_domain_identity.root` |

### API Gateway `module.gateway`

| Terraform resource type             | Terraform resource name | Description                                                                                                                                                                                   |
| ----------------------------------- | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `aws_api_gateway_rest_api`          | `root`                  | REST API for `designguide.me`                                                                                                                                                                 |
| `aws_api_gateway_resource`          | `messages`              | API resource `messages`                                                                                                                                                                       |
| `aws_api_gateway_method`            | `messages_post`         | API method `POST messages`                                                                                                                                                                    |
| `aws_api_gateway_integration`       | `messages_post`         | Link between `module.lambda.messages_post` and `module.gateway.aws_api_gateway_method.messages_post `                                                                                         |
| `aws_api_gateway_method`            | `messages_options`      | API method `OPTIONS messages`                                                                                                                                                                 |
| `aws_api_gateway_integration`       | `messages_options`      | Link between `module.lambda.messages_options` and `module.gateway.aws_api_gateway_method.messages_post `                                                                                      |
| `aws_api_gateway_deployment`        | `v1`                    | API stage `v1`                                                                                                                                                                                |
| `aws_api_gateway_domain_name`       | `api`                   | Custom domain name `api.designguide.me`                                                                                                                                                       |
| `aws_api_gateway_base_path_mapping` | `v1`                    | Map custom domain name `module.gateway.aws_api_gateway_domain_name.api` with REST API `module.gateway.aws_api_gateway_rest_api.root` and stage `module.gateway.aws_api_gateway_deployment.v1` |
| `aws_iam_role`                      | `root`                  | IAM role of `aws_api_gateway_rest_api.root`                                                                                                                                                   |
| `aws_api_gateway_account`           | `root`                  | Account settings. Required to enable Cloudwatch logging                                                                                                                                       |
| `aws_iam_role_policy_attachment`    | `logging`               | Attach `aws_iam_policy` to `aws_iam_role.root` to allow logging                                                                                                                               |
| `aws_api_gateway_method_settings`   | `settings`              | Set throttling and logging for `aws_api_gateway_rest_api.root`                                                                                                                                |

### Lambda `module.function`
 | Terraform resource type          | Terraform resource name               | Description                                                                                                                                                         |
 | -------------------------------- | ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
 | `aws_lambda_function`            | `deployer`                            | Lambda function to retrieve source code of other Lambda functions from `aws_s3_bucket.functions_src` and deploy to `messages_post` and `messages_options` functions |
 | `aws_lambda_function`            | `messages_post`                       | Lambda function to respond to API calls `POST /messages`                                                                                                            |
 | `aws_lambda_function`            | `messages_options`                    | Lambda function to respond to API calls `OPTIONS /messages`                                                                                                         |
 | `aws_iam_role`                   | `deployer`                            | IAM role of `aws_lambda_function.deployer`                                                                                                                          |
 | `aws_iam_role`                   | `messages_post`                       | IAM role of `aws_lambda_function.messages_post`                                                                                                                     |
 | `aws_iam_role`                   | `messages_options`                    | IAM role of `aws_lambda_function.options`                                                                                                                           |
 | `aws_lambda_permission`          | `deployer`                            | Allow invocation of `aws_lambda_function.deployer` from `aws_s3_bucket.functions_src`                                                                               |
 |                                  |
 | `aws_lambda_permission`          | `messages_post`                       | Allow invocation of `aws_lambda_function.messages_post` from `module.gateway.messages_post`                                                                         |
 | `aws_lambda_permission`          | `messages_options`                    | Allow invocation of `aws_lambda_function.messages_options` from `module.gateway.messages_options`                                                                   |
 | `aws_s3_bucket_notification`     | `deployer`                            | Trigger `aws_lambda_function.deployer` from `aws_s3_bucket.functions_src`                                                                                           |
 | `aws_iam_policy`                 | `update_functions`                    | Allow `aws_lambda_function.deployer` to update `aws_lambda_function.messages_post` and `aws_lambda_function.messages_options`                                       |
 | `aws_iam_role_policy_attachment` | `update_functions`                    | Attach `aws_iam_policy.update_functions` to `aws_lambda_function.deployer`                                                                                          |
 | `aws_iam_policy`                 | `access_functions_source_code_bucket` | Allow `aws_lambda_function.deployer` to access `aws_s3_bucket.functions_src`                                                                                        |
 | `aws_iam_role_policy_attachment` | `access_functions_source_code_bucket` | Attach `aws_iam_policy.access_functions_source_code_bucket` to `aws_lambda_function.deployer`                                                                       |
 | `aws_cloudwatch_log_group`       | `deployer_logging`                    | Enable Cloudwatch logging for `aws_lambda_function.deployer`                                                                                                        |
 | `aws_iam_role_policy_attachment` | `deployer_logs`                       | Attach `module.iam.logging` to `aws_lambda_function.deployer`                                                                                                       |
 | `aws_iam_role_policy_attachment` | `messages_post_send_emails`           | Attach `aws_iam_policy.send_mails` to `aws_lambda_function.messages_post` to allow function to send mails                                                           |

### IAM `module.iam`

| Terraform resource type          | Terraform resource name                 | Description                                                                                           |
| -------------------------------- | --------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| `aws_iam_user`                   | `serverless_deployment_user`            | IAM user to deploy [Serverless](https://github.com/pkissling/designguide.me-serverless) via Travis CI |
| `aws_iam_access_key`             | `serverless_deployment_user_access_key` | Access key for programmatic access for `aws_iam_user.serverless_deployment_user`                      |
| `aws_iam_policy`                 | `serverless_deployment`                 | IAM policy to deploy all required Serverless components                                               |
| `aws_iam_user_policy_attachment` | `serverless_deployment`                 | Attach `aws_iam_policy.serverless_deployment` to `aws_iam_user.serverless_deployment_user`            |
| `aws_iam_user`                   | `website_deployment_user`               | IAM user to deploy [SPA](https://github.com/pkissling/designguide.me-vue) via Travis CI               |
| `aws_iam_access_key`             | `website_deployment_user_access_key`    | Access key for programmatic access for `aws_iam_user.website_deployment_user`                         |
| `aws_iam_policy`                 | `website_deployment`                    | IAM policy to deploy to `module.bucket.website` and invalidate `module.cdn.website`                   |
| `aws_iam_user_policy_attachment` | `website_deployment`                    | Attach `aws_iam_policy.website_deployment` to `aws_iam_user.website_deployment_user`                  |
| `aws_iam_policy`                 | `logging`                               | IAM policy to allow creation of log groups / streams and to write logs                                |
| `aws_iam_policy`                 | `send_emails`                           | IAM policy to allow sendings emails from `module.mail.root`                                           |


### SES `module.mail`

| Terraform resource type                | Terraform resource name | Description                                                                         |
| -------------------------------------- | ----------------------- | ----------------------------------------------------------------------------------- |
| `aws_ses_domain_identity`              | `root`                  | Mail domain `designguide.me`                                                        |
| `aws_ses_domain_identity_verification` | `root`                  | Mail domain verification object `designguide.me`                                    |
| `aws_ses_email_identity`               | `recipient`             | Recipient mail address when sending emails from `aws_lambda_function.messages_post` |
