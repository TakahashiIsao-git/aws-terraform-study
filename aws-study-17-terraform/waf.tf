# --------------------------------------------------
# WAF Web ACL
# --------------------------------------------------

# ALBへの基本的なセキュリティ対策
# AWSマネージドルールを利用して
# 一般的なWeb攻撃を自動検知・防御する
# 学習環境のため最小構成とする
resource "aws_wafv2_web_acl" "study_web_acl" {

  name = "${var.project_name}-webacl-v2"

  scope = "REGIONAL"

  # AWS Managed Ruleで判定するため
  # 通常通信は許可する
  default_action {
    allow {}
  }

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

    visibility_config {

      metric_name = "${var.project_name}-webacl"

      cloudwatch_metrics_enabled = true

      sampled_requests_enabled = true
    }
  }

  # 学習環境では以下のエラーが発生するため無効化
  # AccessDeniedException:
  # wafv2:TagResource is not authorized
  # 本番環境では有効化する
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