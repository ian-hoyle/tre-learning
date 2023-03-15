terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "eu-west-2"
  profile = "terraform"
}
/*
resource "aws_instance" "app_server" {
  ami           = "ami-0a1d67b314dac43af"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}
*/
resource "aws_sns_topic" "my_first_sns_topic" {
  name = var.sns_name
}

resource "aws_sns_topic_policy" "my_sns_topic_policy" {
  arn = aws_sns_topic.my_first_sns_topic.arn
  policy = data.aws_iam_policy_document.my_custom_sns_policy_document.json
}

data "aws_iam_policy_document" "my_custom_sns_policy_document" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        var.account_id,
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.my_first_sns_topic.arn,
    ]

    sid = "__default_statement_ID"
  }
}
