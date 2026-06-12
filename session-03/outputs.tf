output "ec2_instance_id" {
  description = "ID of the EC2 instance being monitored"
  value       = aws_instance.monitored.id
}

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.monitored.public_ip
}

output "ec2_ami_used" {
  description = "Amazon Linux 2023 AMI ID selected"
  value       = data.aws_ami.amazon_linux_2023.id
}

output "sns_topic_arn" {
  description = "ARN of the SNS Topic created for CPU alerts"
  value       = aws_sns_topic.cpu_alert.arn
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
