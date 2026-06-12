terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ──────────────────────────────────────────────
# SNS Topic
# ──────────────────────────────────────────────
resource "aws_sns_topic" "cpu_alert" {
  name = var.sns_topic_name

  tags = {
    Lab     = "Session-03"
    Purpose = "CPU-High-Alert"
  }
}

# ──────────────────────────────────────────────
# SNS Email Subscription
# ──────────────────────────────────────────────
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.cpu_alert.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# ──────────────────────────────────────────────
# CloudWatch Alarm — EC2 High CPU
# ──────────────────────────────────────────────
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.ec2_instance_id}-high-cpu-alarm"
  alarm_description   = "Trigger alert when EC2 CPU > ${var.cpu_threshold}% for ${var.evaluation_periods} period(s) of ${var.period_seconds}s"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.period_seconds
  statistic           = "Average"
  threshold           = var.cpu_threshold
  treat_missing_data  = "missing"

  dimensions = {
    InstanceId = var.ec2_instance_id
  }

  # Notify when CPU enters ALARM state
  alarm_actions = [aws_sns_topic.cpu_alert.arn]

  # Notify when CPU recovers to OK state
  ok_actions = [aws_sns_topic.cpu_alert.arn]

  tags = {
    Lab     = "Session-03"
    Purpose = "CPU-High-Alert"
  }
}
