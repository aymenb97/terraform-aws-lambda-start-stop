resource "aws_sns_topic" "start_stop_topic" {
  name            = "scheduled-start-stop-topic"
  delivery_policy = <<JSON
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
} 
JSON
}
resource "aws_sns_topic_subscription" "start_stop_subscription" {
  for_each  = var.emails
  topic_arn = aws_sns_topic.start_stop_topic.arn
  protocol  = "email"
  endpoint  = each.value
}

