# Lambda to forward incoming SES mails to external recipient
resource "aws_lambda_function" "mail_forwarder" {

  function_name = "${local.domain_name_lambda_regex}_mail-forwarder"
  role          = aws_iam_role.mail_forwarder.arn
  handler       = "mail-forwarder.handler"

  s3_bucket = var.bucket_functions_src_id
  s3_key    = "${local.domain_name_lambda_regex}_mail-forwarder.zip"


  runtime = "nodejs12.x"

  environment {
    variables = {
      TO_MAIL               = var.mail_messages_to
      FROM_MAIL             = "mailer@${var.domain}"
      BUCKET_INCOMING_MAILS = var.bucket_incoming_mails_id
    }
  }
}

# Create role to allow deployer function to assume role
resource "aws_iam_role" "mail_forwarder" {
  name               = "${var.domain}-mail_forwarder"
  assume_role_policy = data.aws_iam_policy_document.deployer.json
}
data "aws_iam_policy_document" "mail_forwarder" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Allow exceution of function from SES
resource "aws_lambda_permission" "mail_forwarder" {

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.mail_forwarder.arn
  principal     = "ses.amazonaws.com"
  # source_arn    = var.bucket_functions_src_arn
  # TODO
}

# Allow mail_forwarder to send emails
resource "aws_iam_role_policy_attachment" "mail_forwarder_send_mails" {
  role       = aws_iam_role.mail_forwarder.name
  policy_arn = var.policy_send_email_arn
}

resource "aws_iam_role_policy_attachment" "mail_forwarder_access_incoming_mails_bucket" {
  role       = aws_iam_role.mail_forwarder.name
  policy_arn = var.policy_access_incoming_mails_bucket_arn
}


# Log function output to CloudWatch
resource "aws_cloudwatch_log_group" "mail_forwarder_logging" {
  name              = "/aws/lambda/${aws_lambda_function.mail_forwarder.function_name}"
  retention_in_days = 14
}
# Attach policy for Cloudwatch logging
resource "aws_iam_role_policy_attachment" "mail_forwarder_logging" {
  role       = aws_iam_role.mail_forwarder.name
  policy_arn = var.policy_logging_arn
}
