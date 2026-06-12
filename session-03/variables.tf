variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-southeast-1"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "session03-monitored-ec2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "enable_stress_test" {
  description = "If true, run stress tool on EC2 startup to simulate high CPU"
  type        = bool
  default     = false
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

variable "cpu_threshold" {
  description = "CPU utilization percentage threshold to trigger alarm"
  type        = number
  default     = 80
}

variable "period_seconds" {
  description = "The period in seconds over which the metric is evaluated"
  type        = number
  default     = 300
}

variable "evaluation_periods" {
  description = "Number of consecutive periods that must breach before triggering alarm"
  type        = number
  default     = 1
}
