output "start_event_rule_arn" {
  value       = aws_cloudwatch_event_rule.waketime.arn
  description = "ARN of the Start Eventbridge Rule"

}
output "stop_event_rule_arn" {
  value       = aws_iam_role.lambda_exec.name
  description = "ARN of the Stop Eventbridge Rule"
}
output "S3_bucket_name" {
  description = "S3 bucket name where the lambda functions is stored"
  value       = aws_iam_role.lambda_exec.name
}
