# --------------------------------------------------
# EC2 CPU Alarm
# --------------------------------------------------

# EC2 CPU使用率を監視するCloudWatch Alarm
# CPU使用率がしきい値を超えた状態を継続して検知する
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {

  alarm_name        = "${var.project_name}-cpu-high"
  alarm_description = "Alarm when EC2 CPU utilization exceeds the threshold."

  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"
  statistic   = "Average"
  period      = 300

  comparison_operator = "GreaterThanThreshold"
  threshold           = var.cpu_alarm_threshold
  evaluation_periods  = 3
  datapoints_to_alarm = 2

  # データ欠損時は評価対象外とする
  treat_missing_data = "missing"

  # 学習環境のためアラーム通知は送信しない
  actions_enabled = false

  dimensions = {
    InstanceId = aws_instance.study_ec2.id
  }
}