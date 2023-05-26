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
resource "aws_sns_topic" "orders" {
  name = "orders-topic"
}

resource "aws_sqs_queue" "orders_to_process" {
  name                       = "orders-to-process-queue"
  receive_wait_time_seconds  = 20
  message_retention_seconds  = 18400
}

resource "aws_sqs_queue" "orders_to_notify" {
  name                       = "orders-to-notify-queue"
  receive_wait_time_seconds  = 20
  message_retention_seconds  = 18400
}

resource "aws_sns_topic_subscription" "orders_to_process_subscription" {
  protocol             = "sqs"
  raw_message_delivery = true
  topic_arn            = aws_sns_topic.orders.arn
  endpoint             = aws_sqs_queue.orders_to_process.arn
  filter_policy         = "{\"hello\": [\"ian\"]}"
  filter_policy_scope  = "MessageBody"
}

resource "aws_sns_topic_subscription" "orders_to_notify_subscription" {
  protocol             = "sqs"
  raw_message_delivery = true
  topic_arn            = aws_sns_topic.orders.arn
  endpoint             = aws_sqs_queue.orders_to_notify.arn
}

resource "aws_sqs_queue_policy" "orders_to_process_subscription" {
  queue_url = aws_sqs_queue.orders_to_process.id
  policy    = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": [
        "sqs:SendMessage"
      ],
      "Resource": [
        "${aws_sqs_queue.orders_to_process.arn}"
      ],
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.orders.arn}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_sqs_queue_policy" "orders_to_notify_subscription" {
  queue_url = aws_sqs_queue.orders_to_notify.id
  policy    = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": [
        "sqs:SendMessage"
      ],
      "Resource": [
        "${aws_sqs_queue.orders_to_notify.arn}"
      ],
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.orders.arn}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_sqs_queue" "success_queue" {
  name                       = "success_queue"
  receive_wait_time_seconds  = 20
  message_retention_seconds  = 18400
}

