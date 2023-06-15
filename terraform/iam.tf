data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  managed_policy_arns = [
     aws_iam_policy.lambda_policy.arn
  ]
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}