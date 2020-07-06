terraform {
  backend "s3" {
    bucket         = "designguide.me-tfstate"
    key            = "terraform.state"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "designguide.me-tfstate"
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "bucket" {
  source              = "./bucket"
  domain              = var.domain
  website_cdn_iam_arn = module.cdn.website_cdn_iam_arn
}

module "certificate" {
  source = "./certificate"
  domain = var.domain
}

module "cdn" {
  source              = "./cdn"
  domain              = var.domain
  website_bucket_id   = module.bucket.website_bucket_id
  website_domain_name = module.bucket.website_domain_name
  certificate_arn     = module.certificate.certificate_arn
}

module "domain" {
  source                              = "./domain"
  domain                              = var.domain
  cdn_website_hosted_zone_id          = module.cdn.cdn_website_hosted_zone_id
  cdn_website_domain_name             = module.cdn.cdn_website_domain_name
  cdn_api_domain_name                 = module.gateway.cdn_api_domain_name
  cdn_api_hosted_zone_id              = module.gateway.cdn_api_hosted_zone_id
  certificate_validation_record_name  = module.certificate.certificate_validation_record_name
  certificate_validation_record_type  = module.certificate.certificate_validation_record_type
  certificate_validation_record_value = module.certificate.certificate_validation_record_value
  mail_domain_validation_record_name  = module.mail.mail_domain_validation_record_name
  mail_domain_validation_record_type  = module.mail.mail_domain_validation_record_type
  mail_domain_validation_record_value = module.mail.mail_domain_validation_record_value
}

module "function" {
  source                   = "./function"
  domain                   = var.domain
  mail_messages_from       = var.mail_messages_from
  mail_messages_to         = var.mail_messages_to
  functions_src_bucket_arn = module.bucket.functions_src_bucket_arn
  functions_src_bucket_id  = module.bucket.functions_src_bucket_id
  logging_policy_arn       = module.iam.logging_policy_arn
  send_email_policy_arn    = module.iam.send_email_policy_arn
  gateway_execution_arn    = module.gateway.gateway_execution_arn
}

module "gateway" {
  source                             = "./gateway"
  domain                             = var.domain
  lambda_messages_post_invoke_arn    = module.function.lambda_messages_post_invoke_arn
  lambda_messages_options_invoke_arn = module.function.lambda_messages_options_invoke_arn
  certificate_arn                    = module.certificate.certificate_arn
  logging_policy_arn                 = module.iam.logging_policy_arn

}

module "iam" {
  source                   = "./iam"
  domain                   = var.domain
  functions_src_bucket_arn = module.bucket.functions_src_bucket_arn
  website_bucket_arn       = module.bucket.website_bucket_arn
  website_cdn_arn          = module.cdn.website_cdn_arn
  mail_domain_identity_arn = module.mail.mail_domain_identity_arn
  mail_email_identity_arn  = module.mail.mail_email_identity_arn
}

module "mail" {
  source           = "./mail"
  domain           = var.domain
  mail_messages_to = var.mail_messages_to
}
