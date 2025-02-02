resource "aws_iam_policy" "lambda_policy" {
  name        = "chat_lambda_policy"
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = file("${path.module}/iam/policies/lambda_policy.json")
}

resource "aws_iam_role" "lambda_role" {
  name = "chat_lambda_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = file("${path.module}/iam/roles/lambda_role.json")

  tags = {
    tag-key = "chat_lambda_role"
  }
}

resource "aws_iam_policy_attachment" "lambda_attachment" {
  name       = "chat-attachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.lambda_policy.arn
}