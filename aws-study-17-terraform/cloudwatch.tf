# --------------------------------------------------
# CloudWatch Alarm
# --------------------------------------------------

# EC2 CPU監視
# # CPU使用率が80%以上の状態が15分継続したらALARM

resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {

  alarm_name        = "${var.project_name}-ec2-cpu-high"
  alarm_description = "EC2 CPU Utilization is high"

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3

  metric_name = "CPUUtilization"
  namespace   = "AWS/EC2"

  period    = 300
  statistic = "Average"

  threshold = var.cpu_alarm_threshold

  dimensions = {

    InstanceId = aws_instance.study_ec2.id
  }
}