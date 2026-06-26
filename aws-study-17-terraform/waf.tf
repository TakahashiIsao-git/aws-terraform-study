# --------------------------------------------------
# WAF Web ACL
# --------------------------------------------------

# ALBへの基本的なセキュリティ対策
# AWSマネージドルールを利用して、
# 一般的なWeb攻撃を自動検知・防御する。
# 学習環境のため最小構成とする
resource "aws_wafv2_web_acl" "study_web_acl" {

  name = "${var.project_name}-webacl-v2"

  scope = "REGIONAL"

  # AWS Managed Ruleで判定するため
  # 通常通信は許可する
  default_action {
    allow {}
  }

  # CloudWatchへメトリクスを送信し、
  # WAFの検知状況を可視化する
  visibility_config {

    metric_name = "${var.project_name}-webacl"

    cloudwatch_metrics_enabled = true

    sampled_requests_enabled = true
  }

  # AWS提供のマネージドルール
  # 一般的なWeb攻撃対策
  rule {

    name = "AWSManagedRulesCommonRuleSet"

    priority = 0

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {

        name = "AWSManagedRulesCommonRuleSet"

        vendor_name = "AWS"
      }
    }

    # ルール単位でメトリクスを取得する
    visibility_config {

      metric_name = "${var.project_name}-webacl"

      cloudwatch_metrics_enabled = true

      sampled_requests_enabled = true
    }
  }

  # 学習環境ではwafv2:TagResource 権限が付与されていないため、
  # AccessDeniedExceptionが発生する。
  # 本番環境ではタグ管理のため有効化する。
  # tags = {

  # Name = "${var.project_name}-webacl-v2"
  # }
}

# --------------------------------------------------
# WAF Association
# --------------------------------------------------

# ALBへWAFを関連付け
# AssociationしないとWAFは機能しない
resource "aws_wafv2_web_acl_association" "study_waf_association" {

  resource_arn = aws_lb.study_alb.arn

  web_acl_arn = aws_wafv2_web_acl.study_web_acl.arn
}

# --------------------------------------------------
# WAF Log Group
# --------------------------------------------------

# 学習環境では logs:CreateLogGroup 権限が付与されていないため、
# AccessDenied が発生する。
# Terraformコードの学習目的として残し、実際の作成はコメントアウトしている。
# 本番環境では有効化する
# resource "aws_cloudwatch_log_group" "waf_log" {

# name = "aws/waf/${var.project_name}"

# retention_in_days = 7
# }

# --------------------------------------------------
# WAF Logging Configuration
# --------------------------------------------------

# WAFで許可・ブロックされたリクエストをCloudWatch Logsへ保存する。
# CloudWatch Logs出力先の作成権限不足のため、
# 学習環境ではコメントアウト。
# 本番環境ではWAFの検知・ブロックログを
# CloudWatch Logsへ出力する。
# resource "aws_wafv2_web_acl_logging_configuration" "waf_logging" {

# resource_arn = aws_wafv2_web_acl.study_web_acl.arn

# log_destination_configs = [
#   aws_cloudwatch_log_group.waf_log.arn
# ]  
# }