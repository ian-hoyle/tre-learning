# TRE-Forward Lambda
resource "aws_lambda_function" "tre_forward" {
  image_uri     = "101128015902.dkr.ecr.eu-west-2.amazonaws.com/lambda-scala-example:84a06796ccea9133dbbdb00ddc055d12777cb33d"
  package_type  = "Image"
  function_name = "my_test_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  timeout       = 30

  tags = {
    "ApplicationType" = "Java"
  }
}

resource "aws_lambda_function_event_invoke_config" "example" {
  function_name = aws_lambda_function.tre_forward.function_name

  destination_config {
    on_failure {
      destination =  aws_sns_topic.orders.arn
    }

    on_success {
      destination =  aws_sns_topic.orders.arn
    }
  }
}

data "aws_iam_policy_document" "lambda_policy_document" {
  statement {

    effect = "Allow"

    actions = [
      "SNS:Publish"
    ]

    resources = [
      aws_sns_topic.orders.arn
    ]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name_prefix = "lambda_policy"
  path        = "/"
  policy      = data.aws_iam_policy_document.lambda_policy_document.json
  lifecycle {
    create_before_destroy = true
  }
}

