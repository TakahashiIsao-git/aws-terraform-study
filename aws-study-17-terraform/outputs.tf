# ----------------------------------
# Outputs
# ----------------------------------

# ----------------------------------
# VPC
# ----------------------------------

# VPC ID
# 作成したVPCを識別するため出力する
output "vpc_id" {

  description = "VPC ID"
  value       = aws_vpc.study_vpc.id
}

# ----------------------------------
# ALB
# ----------------------------------

# ALB DNS Name
# ブラウザから接続確認するため出力する
output "alb_dns_name" {

  description = "ALB DNS Name"
  value       = aws_lb.study_alb.dns_name
}

# ----------------------------------
# EC2
# ----------------------------------

# EC2 Instance ID
# 作成したEC2を識別するため出力する
output "ec2_instance_id" {

  description = "EC2 Instance ID"
  value       = aws_instance.study_ec2.id
}

# ----------------------------------
# RDS
# ----------------------------------

# RDS Endpoint
# EC2からDB接続する接続先を確認するため出力する
output "rds_endpoint" {

  description = "RDS Endpoint"
  value       = aws_db_instance.study_rds.address
}

# ----------------------------------
# CloudWatch
# ----------------------------------

# CloudWatch Alarm
# 作成した監視アラーム名を確認するため出力する
output "cloudwatch_alarm_name" {

  description = "EC2 CPU Alarm Name"
  value       = aws_cloudwatch_metric_alarm.ec2_cpu_high.alarm_name
}

# ----------------------------------
# WAF
# ----------------------------------

# WAF Web ACL ARN
# ALBへ適用されたWAFを識別するため出力する
output "waf_web_acl_arn" {

  description = "WAF Web ACL Arn"
  value       = aws_wafv2_web_acl.study_web_acl.arn
}

# ----------------------------------
# WAF Log Group
# ----------------------------------

# 学習環境ではlogs:CreateLogGroup権限が付与されておらず、
# AccessDeniedが発生するためコメントアウトして保持する。
# 本番環境では有効化し、WAFログの保存先として利用する。
# output "waf_log_group" {

# WAFログ保存先のLog Group名を出力する
# description = "WAF Log Group Name"

# WAFログ保存先のCloudWatch Logs名を出力する
# value = aws_cloudwatch_log_group.waf_log.name
# }