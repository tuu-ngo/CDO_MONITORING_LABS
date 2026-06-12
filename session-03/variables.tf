variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-southeast-1"
}

variable "sns_topic_name" {
  description = "Name for the SNS topic"
  type        = string
  default     = "cpu-alert-topic"
}

variable "alert_email" {
  description = "Email address to receive CPU alert notifications"
  type        = string
}

variable "ec2_instance_id" {
  description = "EC2 Instance ID to monitor (e.g. i-0abc1234def56789)"
  type        = string
}

variable "cpu_threshold" {
  description = "CPU utilization percentage threshold to trigger alarm"
  type        = number
  default     = 80
}

variable "period_seconds" {
  description = "The period in seconds over which the metric is evaluated"
  type        = number
  default     = 300 # 5 minutes
}

variable "evaluation_periods" {
  description = "Number of periods that must breach before triggering alarm"
  type        = number
  default     = 1
}
