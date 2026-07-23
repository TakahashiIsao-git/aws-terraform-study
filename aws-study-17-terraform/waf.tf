# --------------------------------------------------
# WAF Web ACL
# --------------------------------------------------

# ALBを保護するWAF
# AWS Managed Rulesを利用した最小構成
resource "aws_wafv2_web_acl" "study_web_acl" {

  name  = "${var.project_name}-webacl-v2"
  scope = "REGIONAL"

  # AWS Managed Rulesで許可・ブロックを判定するため、
  # デフォルトでは通信を許可する
  default_action {
    allow {}
  }

  # CloudWatchメトリクスを有効化
  visibility_config {

    metric_name                = "${var.project_name}-webacl"
    cloudwatch_metrics_enabled = true
    sampled_requests_enabled   = true
  }

  # AWS提供の共通マネージドルールを適用
  rule {

    name     = "AWSManagedRulesCommonRuleSet"
    priority = 0

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    # ルール単位のCloudWatchメトリクスを有効化
    visibility_config {

      metric_name                = "${var.project_name}-webacl"
      cloudwatch_metrics_enabled = true
      sampled_requests_enabled   = true
    }
  }

  # 学習環境ではTagResource権限がないため無効化
  # tags = {
  #   Name = "${var.project_name}-webacl-v2"
  # }
}

# --------------------------------------------------
# WAF Association
# --------------------------------------------------

# ALBへWAFを関連付ける
# 関連付けないとWAFは適用されない
resource "aws_wafv2_web_acl_association" "study_waf_association" {

  resource_arn = aws_lb.study_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.study_web_acl.arn
}

# --------------------------------------------------
# WAF Log Group
# --------------------------------------------------

# IAM権限不足のため学習環境では無効化
# resource "aws_cloudwatch_log_group" "waf_log" {

#   name              = "aws/waf/${var.project_name}"
#   retention_in_days = 7
# }

# --------------------------------------------------
# WAF Logging Configuration
# --------------------------------------------------

# WAFで許可・ブロックされたリクエストをCloudWatch Logsへ保存する。
# 学習環境ではIAM権限不足のため無効化
# resource "aws_wafv2_web_acl_logging_configuration" "waf_logging" {

#   resource_arn = aws_wafv2_web_acl.study_web_acl.arn

#   log_destination_configs = [
#     aws_cloudwatch_log_group.waf_log.arn
#   ]  
# }