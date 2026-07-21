# ----------------------------------
# Outputs
# ----------------------------------

# ----------------------------------
# VPC
# ----------------------------------

# 作成したVPC ID
output "vpc_id" {
  description = "ID of the created VPC."
  value       = aws_vpc.study_vpc.id
}

# ----------------------------------
# ALB
# ----------------------------------

# ALBのDNS名
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer."
  value       = aws_lb.study_alb.dns_name
}

# ----------------------------------
# EC2
# ----------------------------------

# EC2インスタンスのID
output "ec2_instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.study_ec2.id
}

# ----------------------------------
# RDS
# ----------------------------------

# RDSエンドポイント
output "rds_endpoint" {
  description = "Endpoint of the RDS instance."
  value       = aws_db_instance.study_rds.address
}

# ----------------------------------
# CloudWatch
# ----------------------------------

# CloudWatch Alarm名
output "cloudwatch_alarm_name" {
  description = "Name of the EC2 CPU CloudWatch alarm."
  value       = aws_cloudwatch_metric_alarm.ec2_cpu_high.alarm_name
}

# ----------------------------------
# WAF
# ----------------------------------

# WAF Web ACL ARN
output "waf_web_acl_arn" {
  description = "ARN of the WAF Web ACL."
  value       = aws_wafv2_web_acl.study_web_acl.arn
}

# ----------------------------------
# WAF Log Group
# ----------------------------------

# 学習環境ではIAM権限不足のためコメントアウト
# 本番環境では有効化する
# output "waf_log_group" {
#   description = "Name of the WAF Log Group."
#   value       = aws_cloudwatch_log_group.waf_log.name
# }