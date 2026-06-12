# Session 03 — CloudWatch Alarm → Email Alert via SNS

> **Lab:** Send an email alert when EC2 CPU > 80% for 5 consecutive minutes  
> **Course:** Mastering AWS System Monitoring — TechX Training

## Architecture

```
EC2 Instance (CPU > 80% for 5 min)
        │
        ▼
CloudWatch Alarm ──► SNS Topic: cpu-alert-topic
                              │
                              ▼
                     Email Subscription
                     (your-email@example.com)
```

## Resources Created

| Resource | Type | Description |
|---|---|---|
| `cpu-alert-topic` | `aws_sns_topic` | SNS topic for CPU alerts |
| Email subscription | `aws_sns_topic_subscription` | Subscribes your email to the topic |
| `<instance-id>-high-cpu-alarm` | `aws_cloudwatch_metric_alarm` | Triggers at CPU > 80% |

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.3.0
- AWS CLI configured (`aws configure`)  
- IAM permissions: `cloudwatch:*`, `sns:*`
- A running EC2 instance (note its Instance ID)

## Quick Start

### 1. Clone the repo

```bash
git clone https://github.com/<your-username>/CDO_Monitoring_Labs.git
cd CDO_Monitoring_Labs/session-03
```

### 2. Tạo file terraform.tfvars

```bash
cp terraform.tfvars.example terraform.tfvars
```

Mở `terraform.tfvars` và điền thông tin:

```hcl
aws_region      = "ap-southeast-1"
alert_email     = "your-email@example.com"   # email nhận alert
ec2_instance_id = "i-0xxxxxxxxxxxxxxxx"       # EC2 Instance ID
```

### 3. Deploy

```bash
terraform init
terraform plan
terraform apply
```

### 4. Xác nhận Email Subscription

Sau khi `terraform apply` hoàn thành:
1. Kiểm tra hòm thư email của bạn
2. Tìm email từ **AWS Notifications** với tiêu đề `AWS Notification - Subscription Confirmation`
3. Click vào link **Confirm subscription**

> **Quan trọng:** SNS sẽ không gửi alert cho đến khi bạn xác nhận subscription.

### 5. Kiểm tra Alarm trên Console

```
CloudWatch → Alarms → All alarms
```

Alarm sẽ ở trạng thái **OK** nếu CPU đang bình thường, hoặc **INSUFFICIENT_DATA** nếu chưa đủ dữ liệu.

## Test Alarm (Optional)

SSH vào EC2 và chạy stress test:

```bash
# Cài stress tool (Amazon Linux 2)
sudo yum install stress -y

# Tạo tải CPU trong 6 phút (vượt ngưỡng 5 phút)
stress --cpu 4 --timeout 360
```

Sau ~5 phút, bạn sẽ nhận được email alert.

## Cleanup

```bash
terraform destroy
```

## Variables Reference

| Variable | Default | Description |
|---|---|---|
| `aws_region` | `ap-southeast-1` | AWS Region |
| `sns_topic_name` | `cpu-alert-topic` | Tên SNS Topic |
| `alert_email` | *(required)* | Email nhận thông báo |
| `ec2_instance_id` | *(required)* | EC2 Instance ID cần monitor |
| `cpu_threshold` | `80` | Ngưỡng CPU (%) |
| `period_seconds` | `300` | Chu kỳ đánh giá (giây) |
| `evaluation_periods` | `1` | Số chu kỳ liên tiếp vi phạm để trigger |
