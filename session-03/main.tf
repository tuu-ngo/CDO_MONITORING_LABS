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

locals {
  user_data_stress = <<-EOF
    #!/bin/bash
    yum install -y stress
    stress --cpu 4 --timeout 400 &
  EOF
}

# ──────────────────────────────────────────────
# Data: Latest Amazon Linux 2023 AMI
# ──────────────────────────────────────────────
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# ──────────────────────────────────────────────
# Data: Default VPC
# ──────────────────────────────────────────────
data "aws_vpc" "default" {
  default = true
}

# ──────────────────────────────────────────────
# Security Group — allow outbound only (no SSH needed for CPU test)
# ──────────────────────────────────────────────
resource "aws_security_group" "ec2_sg" {
  name        = "${var.instance_name}-sg"
  description = "Security group for Session-03 lab EC2"
  vpc_id      = data.aws_vpc.default.id

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Lab     = "Session-03"
    Purpose = "CPU-High-Alert"
  }
}

# ──────────────────────────────────────────────
# EC2 Instance
# ──────────────────────────────────────────────
resource "aws_instance" "monitored" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = var.enable_stress_test ? local.user_data_stress : null

  tags = {
    Name    = var.instance_name
    Lab     = "Session-03"
    Purpose = "CPU-High-Alert"
  }
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
  alarm_name          = "${var.instance_name}-high-cpu-alarm"
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
    InstanceId = aws_instance.monitored.id
  }

  alarm_actions = [aws_sns_topic.cpu_alert.arn]
  ok_actions    = [aws_sns_topic.cpu_alert.arn]

  tags = {
    Lab     = "Session-03"
    Purpose = "CPU-High-Alert"
  }
}
