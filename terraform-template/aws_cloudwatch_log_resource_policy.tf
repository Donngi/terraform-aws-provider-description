# AWS CloudWatch Logs リソースポリシー
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudwatch_log_resource_policy
# Provider Version: 6.28.0
# Generated: 2026-02-12
# NOTE: CloudWatch Logsのリソースポリシーを定義し、他のAWSサービスからのログ配信を許可します。
#       Route 53のクエリログ、VPCフローログなどがロググループにアクセスする際に必要です。

#---------------------------------------
# 基本設定
#---------------------------------------
resource "aws_cloudwatch_log_resource_policy" "example" {
  # ポリシー名
  # 設定内容: CloudWatch Logsリソースポリシーの一意な名前
  # 設定可能な値: 1～255文字の英数字、ハイフン、アンダースコア
  # 省略時: 設定不可（必須項目）
  policy_name = "example-policy"

  # ポリシードキュメント
  # 設定内容: IAMポリシードキュメント形式のJSON文字列
  # 設定可能な値: 有効なJSONポリシードキュメント（最大5120文字）
  # 省略時: 設定不可（必須項目）
  # 注意: Principal、Action、Resource、Effectを含む有効なIAMポリシー形式が必要
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "route53.amazonaws.com"
        }
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:log-group:/aws/route53/*"
      }
    ]
  })

  #---------------------------------------
  # オプション設定
  #---------------------------------------
  # リージョン
  # 設定内容: このリソースが管理されるAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-east-1"

  # リソース識別子
  # 設定内容: Terraformリソースの一意な識別子
  # 設定可能な値: 任意の文字列
  # 省略時: policy_nameの値が自動的に使用される
  id = "custom-id"
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# id          - ポリシー名（policy_name）
# policy_name - 設定されたポリシー名
# region      - リソースが管理されているリージョン
