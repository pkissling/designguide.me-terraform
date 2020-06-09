# [designguide.me](https://designguide.me)
[![Build Status](https://travis-ci.org/pkissling/designguide.me-terraform.svg?branch=master)](https://travis-ci.org/pkissling/designguide.me-terraform)

## Overview
Terraform project to setup required AWS infrastructure for [designguide.me](https://designguide.me), which contains:
- S3 bucket for static website hosting
- Cloudfront distribution to serve website
- ACM certificate to serve traffic via https
- AWS lambda as the backend
- API gateway to consolidate lambda function
- Route53 hosted zone for domain and `api.` subdomain

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

| Terraform resource type | Terraform resource name | Description            |
| ----------------------- | ----------------------- | ---------------------- |
| `aws_s3_bucket`         | `website`               | Website static content |
| `aws_s3_bucket`         | `website_logs`          | Website access logs    |

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
| `aws_api_gateway_integration`       | `messages_lambda`       | Link between `module.lambda.messages` and `module.gateway.aws_api_gateway_method.messages_post `                                                                                              |
| `aws_api_gateway_deployment`        | `v1`                    | API stage `v1`                                                                                                                                                                                |
| `aws_api_gateway_domain_name`       | `api`                   | Custom domain name `api.designguide.me`                                                                                                                                                       |
| `aws_api_gateway_base_path_mapping` | `v1`                    | Map custom domain name `module.gateway.aws_api_gateway_domain_name.api` with REST API `module.gateway.aws_api_gateway_rest_api.root` and stage `module.gateway.aws_api_gateway_deployment.v1` |

### IAM `module.iam`

| Terraform resource type          | Terraform resource name              | Description                                                                                 |
| -------------------------------- | ------------------------------------ | ------------------------------------------------------------------------------------------- |
| `aws_iam_user`                   | `website_deployment_user`            | IAM user to deploy to `module.bucket.website`                                               |
| `aws_iam_access_key`             | `website_deployment_user_access_key` | Access key for programmatic access for `aws_iam_user.website_deployment_user`               |
| `aws_iam_policy`                 | `website_deployment_policy`          | IAM policy to access `module.bucket.website`                                                |
| `aws_iam_user_policy_attachment` | `website_deployment`                 | Attach `aws_iam_policy.website_deployment_policy` to `aws_iam_user.website_deployment_user` |

### Lambda `module.lambda`

| Terraform resource type | Terraform resource name | Description                                                |
| ----------------------- | ----------------------- | ---------------------------------------------------------- |
| `aws_lambda_function`   | `messages`              | Lambda function to serve `POST api.desinguide.me/messages` |

### SES `module.mail`

| Terraform resource type                | Terraform resource name | Description                                      |
| -------------------------------------- | ----------------------- | ------------------------------------------------ |
| `aws_ses_domain_identity`              | `root`                  | Mail domain `designguide.me`                     |
| `aws_ses_domain_identity_verification` | `root`                  | Mail domain verification object `designguide.me` |
