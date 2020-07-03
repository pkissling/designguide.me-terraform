resource "aws_iam_policy" "logging" {
  name        = "${var.domain}-logging"
  path        = "/"
  description = "Create log groups and log messages"

  policy = data.template_file.logging_policy.rendered
}

data "template_file" "logging_policy" {
  template = file("${path.module}/logging_policy.json")
}