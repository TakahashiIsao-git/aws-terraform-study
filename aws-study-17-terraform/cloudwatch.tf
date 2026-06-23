# --------------------------------------------------
# CloudWatch Alarm
# --------------------------------------------------

# EC2 CPU監視
# 5分間隔で3回評価し、そのうち2回以上CPU使用率が80%超でALARM

resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {

  alarm_name        = "${var.project_name}-ec2-cpu-high"
  alarm_description = "EC2 CPU Utilization is high"

  comparison_operator = "GreaterThanThreshold"
  threshold           = var.cpu_alarm_threshold

  evaluation_periods  = 3
  datapoints_to_alarm = 2

  treat_missing_data = "missing"
  actions_enabled    = false

  metric_name = "CPUUtilization"
  namespace   = "AWS/EC2"

  period    = 300
  statistic = "Average"

  dimensions = {

    InstanceId = aws_instance.study_ec2.id
  }
}