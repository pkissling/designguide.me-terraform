Terraform project to setup required AWS infrastructure for [designguide.me](https://designguide.me).

# Modules
## S3 `module.bucket`
| Terraform resource type | Terraform resource name | Description            |
| ----------------------- | ----------------------- | ---------------------- |
| `aws_s3_bucket`         | `website`               | Website static content |
| `aws_s3_bucket`         | `website_logs`          | Website access logs    |

## Cloudfront `module.cdn`
| Terraform resource type       | Terraform resource name | Description          |
| ----------------------------- | ----------------------- | -------------------- |
| `aws_cloudfront_distribution` | `website`               | CDN to serve website |

## Certificate Manager `module.certificate`
| Terraform resource type | Terraform resource name | Description                  |
| ----------------------- | ----------------------- | ---------------------------- |
| `aws_acm_certificate`   | `root`                  | Certificate `designguide.me` |
| `aws_acm_certificate_validation`   | `root`                  | Certificate validation object `designguide.me` |

## Route53 `module.domain`
| Terraform resource type | Terraform resource name  | Description                                                        |
| ----------------------- | ------------------------ | ------------------------------------------------------------------ |
| `aws_route53_zone`      | `root`                   | Hosted zone `designguide.me`                                       |
| `aws_route53_record`    | `root`                   | DNS record `designguide.me`                                        |
| `aws_route53_record`    | `www`                    | DNS record `www.designguide.me`                                    |
| `aws_route53_record`    | `api`                    | DNS record `api.designguide.me`                                    |
| `aws_route53_record`    | `certificate_validation` | DNS record to validate certificate `aws_acm_certificate.root`      |
| `aws_route53_record`    | `mail_domain_validation` | DNS record to validate email domain `aws_ses_domain_identity.root` |

## API Gateway `module.gateway`
| Terraform resource type             | Terraform resource name | Description                                                                                                                                                                                   |
| ----------------------------------- | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `aws_api_gateway_rest_api`          | `root`                  | REST API for `designguide.me`                                                                                                                                                                 |
| `aws_api_gateway_resource`          | `messages`              | API resource `messages`                                                                                                                                                                       |
| `aws_api_gateway_method`            | `messages_post`         | API method `POST messages`                                                                                                                                                                    |
| `aws_api_gateway_integration`       | `messages_lambda`       | Link between `module.lambda.messages` and `module.gateway.aws_api_gateway_method.messages_post `                                                                                                                     |
| `aws_api_gateway_deployment`        | `v1`                    | API stage `v1`                                                                                                                                                                                |
| `aws_api_gateway_domain_name`       | `api`                   | Custom domain name `api.designguide.me`                                                                                                                                                       |
| `aws_api_gateway_base_path_mapping` | `v1`                    | Map custom domain name `module.gateway.aws_api_gateway_domain_name.api` with REST API `module.gateway.aws_api_gateway_rest_api.root` and stage `module.gateway.aws_api_gateway_deployment.v1` |

## Lambda `module.lambda`
| Terraform resource type | Terraform resource name | Description                                                |
| ----------------------- | ----------------------- | ---------------------------------------------------------- |
| `aws_lambda_function`   | `messages`              | Lambda function to serve `POST api.desinguide.me/messages` |

## SES `module.mail`
| Terraform resource type   | Terraform resource name | Description                  |
| ------------------------- | ----------------------- | ---------------------------- |
| `aws_ses_domain_identity` | `root`                  | Mail domain `designguide.me` |
| `aws_ses_domain_identity_verification` | `root`                  | Mail domain verification object `designguide.me` |