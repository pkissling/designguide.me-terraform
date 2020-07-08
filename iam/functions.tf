# Permit updating Lambda functions
resource "aws_iam_policy" "update_functions" {
  name        = "${var.domain}-update_lambda_functions"
  path        = "/"
  description = "Update Lambda functions"
  policy      = data.aws_iam_policy_document.update_functions.json
}

data "aws_iam_policy_document" "update_functions" {
  statement {
    actions = ["lambda:UpdateFunctionCode"]

    resources = [
      var.lambda_mail_forwarder_arn,
      var.lambda_messages_options_arn,
      var.lambda_messages_post_arn
    ]
  }
}
