output "sns_topic_arn" {
  description = "ARN of the SNS Topic created for CPU alerts"
  value       = aws_sns_topic.cpu_alert.arn
}

output "sns_topic_name" {
  description = "Name of the SNS Topic"
  value       = aws_sns_topic.cpu_alert.name
}

output "cloudwatch_alarm_name" {
  description = "Name of the CloudWatch Alarm"
  value       = aws_cloudwatch_metric_alarm.high_cpu.alarm_name
}

output "cloudwatch_alarm_arn" {
  description = "ARN of the CloudWatch Alarm"
  value       = aws_cloudwatch_metric_alarm.high_cpu.arn
}

output "subscription_confirmation_note" {
  description = "Reminder to confirm email subscription"
  value       = "ACTION REQUIRED: Check your inbox at '${var.alert_email}' and click the confirmation link from AWS to activate the SNS subscription."
}
