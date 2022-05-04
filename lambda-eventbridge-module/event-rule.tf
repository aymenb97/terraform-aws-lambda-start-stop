resource "aws_cloudwatch_event_rule" "waketime" {
  name        = "instances-wakeup-event"
  description = "Start all stopped instances on Schedule"
  #schedule_expression = "cron(${var.waketime})"
  schedule_expression = "rate(5 minutes)"


}

resource "aws_cloudwatch_event_rule" "bedtime" {
  name                = "instances-bedtime-event"
  description         = "Stop all started instances on Schedule"
  schedule_expression = "cron(${var.bedtime})"

}

resource "aws_cloudwatch_event_target" "lambda_wakeup" {
  rule      = aws_cloudwatch_event_rule.waketime.name
  target_id = "lambda_function"
  arn       = aws_lambda_function.lambda_start_stop.arn
  input     = <<JSON
  {
  "eventType": "${var.start_event_name}"
  }
 JSON
}
resource "aws_cloudwatch_event_target" "lambda_bedtime" {
  rule      = aws_cloudwatch_event_rule.bedtime.name
  target_id = "lambda_function"
  arn       = aws_lambda_function.lambda_start_stop.arn
  input     = <<JSON
  {
   "eventType": "${var.stop_event_name}"   
  }
 JSON
}

resource "aws_lambda_permission" "allow_cloudwatch_waktetime_to_invoke" {
  statement_id  = "AllowWaktimeExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "schedule-start-stop"
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.waketime.arn
}
resource "aws_lambda_permission" "allow_cloudwatch_bedtime_to_invoke" {
  statement_id  = "AllowBedtimeExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "schedule-start-stop"
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.bedtime.arn
}
