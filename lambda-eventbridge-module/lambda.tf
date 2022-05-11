terraform {
  required_providers {

    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = "~> 1.0"
}

resource "random_pet" "lambda_bucket_name" {
  prefix = "lambda-schedule-start-stop"
  length = 2
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = random_pet.lambda_bucket_name.id
  force_destroy = true
}

data "archive_file" "lambda_rest_api" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda-function-start-stop"
  output_path = "${path.module}/../lambda-function-start-stop.zip"
}
data "aws_region" "current" {}
resource "aws_s3_object" "lambda_rest_api" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda-start-stop.zip"
  source = data.archive_file.lambda_rest_api.output_path
  etag   = filemd5(data.archive_file.lambda_rest_api.output_path)
}
resource "aws_iam_role" "lambda_exec" {
  name = "lambda-ec2"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy_attachment" "cloudwatch_ec2_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchActionsEC2Access"
}
resource "aws_iam_role_policy_attachment" "sns_full_access" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"

}
resource "aws_lambda_function" "lambda_start_stop" {
  function_name = "schedule-start-stop"
  s3_bucket     = aws_s3_bucket.lambda_bucket.id
  s3_key        = aws_s3_object.lambda_rest_api.key
  runtime       = "python3.8"
  handler       = "main.handler"

  source_code_hash = data.archive_file.lambda_rest_api.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
  environment {
    variables = {
      TAG_KEY               = var.tag_key,
      TAG_VALUE             = var.tag_value,
      START_INSTANCES_EVENT = var.start_event_name,
      STOP_INSTANCES_EVENT  = var.stop_event_name
      REGION                = data.aws_region.current.name
      TOPIC_ARN             = aws_sns_topic.start_stop_topic.arn
    }
  }
}
