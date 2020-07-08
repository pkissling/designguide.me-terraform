terraform {
  backend "s3" {
    bucket         = "designguide.me-tfstate"
    key            = "terraform.state"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "designguide.me-tfstate"
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "bucket" {
  source              = "./bucket"
  domain              = var.domain
  cdn_website_iam_arn = module.cdn.cdn_website_iam_arn
  aws_account_id      = module.utilities.aws_account_id
}

module "certificate" {
  source = "./certificate"
  domain = var.domain
}

module "cdn" {
  source                     = "./cdn"
  domain                     = var.domain
  bucket_website_domain_name = module.bucket.bucket_website_domain_name
  bucket_website_id          = module.bucket.bucket_website_id
  certificate_arn            = module.certificate.certificate_arn
}

module "domain" {
  source                              = "./domain"
  domain                              = var.domain
  certificate_validation_record_name  = module.certificate.certificate_validation_record_name
  certificate_validation_record_type  = module.certificate.certificate_validation_record_type
  certificate_validation_record_value = module.certificate.certificate_validation_record_value
  cdn_website_domain_name             = module.cdn.cdn_website_domain_name
  cdn_website_hosted_zone_id          = module.cdn.cdn_website_hosted_zone_id
  cdn_api_hosted_zone_id              = module.gateway.cdn_api_hosted_zone_id
  cdn_api_domain_name                 = module.gateway.cdn_api_domain_name
  mail_domain_validation_record_name  = module.mail.mail_domain_validation_record_name
  mail_domain_validation_record_type  = module.mail.mail_domain_validation_record_type
  mail_domain_validation_record_value = module.mail.mail_domain_validation_record_value
}

module "function" {
  source                                         = "./function"
  domain                                         = var.domain
  mail_messages_to                               = var.mail_messages_to
  bucket_functions_src_arn                       = module.bucket.bucket_functions_src_arn
  bucket_functions_src_id                        = module.bucket.bucket_functions_src_id
  bucket_incoming_mails_arn                      = module.bucket.bucket_incoming_mails_arn
  bucket_incoming_mails_id                       = module.bucket.bucket_incoming_mails_id
  gateway_execution_arn                          = module.gateway.gateway_execution_arn
  policy_logging_arn                             = module.iam.policy_logging_arn
  policy_send_email_arn                          = module.iam.policy_send_email_arn
  policy_update_functions_arn                    = module.iam.policy_update_functions_arn
  policy_access_functions_source_code_bucket_arn = module.iam.policy_access_functions_source_code_bucket_arn
  policy_access_incoming_mails_bucket_arn        = module.iam.policy_access_incoming_mails_bucket_arn
}

module "gateway" {
  source                             = "./gateway"
  domain                             = var.domain
  certificate_arn                    = module.certificate.certificate_arn
  policy_logging_arn                 = module.iam.policy_logging_arn
  lambda_messages_options_invoke_arn = module.function.lambda_messages_options_invoke_arn
  lambda_messages_post_invoke_arn    = module.function.lambda_messages_post_invoke_arn

}

module "iam" {
  source                      = "./iam"
  domain                      = var.domain
  bucket_functions_src_arn    = module.bucket.bucket_functions_src_arn
  bucket_incoming_mails_arn   = module.bucket.bucket_incoming_mails_arn
  bucket_website_arn          = module.bucket.bucket_website_arn
  cdn_website_arn             = module.cdn.cdn_website_arn
  lambda_mail_forwarder_arn   = module.function.lambda_mail_forwarder_arn
  lambda_messages_options_arn = module.function.lambda_messages_options_arn
  lambda_messages_post_arn    = module.function.lambda_messages_post_arn
  mail_domain_identity_arn    = module.mail.mail_domain_identity_arn
  mail_email_identity_arn     = module.mail.mail_email_identity_arn
}

module "mail" {
  source                    = "./mail"
  domain                    = var.domain
  mail_messages_to          = var.mail_messages_to
  bucket_incoming_mails_id  = module.bucket.bucket_incoming_mails_id
  lambda_mail_forwarder_arn = module.function.lambda_mail_forwarder_arn
}

module "utilities" {
  source = "./utilities"
}
