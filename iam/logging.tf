resource "aws_iam_policy" "logging" {
  name        = "${var.domain}-logging"
  path        = "/"
  description = "Create log groups and log messages"

  policy = data.aws_iam_policy_document.logging_policy.json
}

data "aws_iam_policy_document" "logging_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents"
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}
