#########################################################################
# AWS CloudSearch Domain Service Access Policy
#########################################################################
# CloudSearchドメインへのアクセスを制御するIAMポリシーを定義するリソース。
# 特定のAWSサービスやプリンシパルに対してCloudSearchドメインへのアクセス権限を付与。
#
# 主な用途:
# - CloudSearchドメインへのアクセス制御
# - サービス間連携の権限管理
# - IAMベースのアクセスポリシー設定
#
# 関連リソース:
# - aws_cloudsearch_domain - CloudSearchドメイン本体
#
# Provider Version: 6.28.0
# Generated: 2026-02-12
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudsearch_domain_service_access_policy
# NOTE: このリソースはCloudSearchドメインへのアクセス権限を管理し、ドメイン削除時に自動的に削除されます。

#-----------------------------------------------------------------------
# 基本設定
#-----------------------------------------------------------------------
resource "aws_cloudsearch_domain_service_access_policy" "example" {
  # 設定内容: CloudSearchドメイン名
  # 設定可能な値: 既存のCloudSearchドメイン名（3-28文字、英小文字・数字・ハイフンのみ）
  # 省略時: 必須項目（省略不可）
  domain_name = "example-domain"

  # 設定内容: ドメインへのアクセスを制御するIAMポリシードキュメント（JSON形式）
  # 設定可能な値: 有効なIAMポリシーJSON文字列
  # 省略時: 必須項目（省略不可）
  access_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action   = "cloudsearch:*"
        Resource = "arn:aws:cloudsearch:us-east-1:123456789012:domain/example-domain"
      }
    ]
  })
}

#-----------------------------------------------------------------------
# リージョン設定
#-----------------------------------------------------------------------
resource "aws_cloudsearch_domain_service_access_policy" "regional" {
  domain_name = "example-domain"
  access_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { AWS = "*" }
        Action    = "cloudsearch:search"
        Resource  = "*"
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "203.0.113.0/24"
          }
        }
      }
    ]
  })

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（us-east-1、ap-northeast-1など）
  # 省略時: プロバイダーの設定リージョンを使用
  region = "us-west-2"
}

#-----------------------------------------------------------------------
# タイムアウト設定
#-----------------------------------------------------------------------
# resource "aws_cloudsearch_domain_service_access_policy" "with_timeouts" {
#   domain_name   = "example-domain"
#   access_policy = jsonencode({ /* ... */ })
#
#   timeouts {
#     # 設定内容: ポリシー更新操作のタイムアウト時間
#     # 設定可能な値: 時間文字列（例: "20m", "1h"）
#     # 省略時: デフォルトのタイムアウト値を使用
#     update = "20m"
#
#     # 設定内容: ポリシー削除操作のタイムアウト時間
#     # 設定可能な値: 時間文字列（例: "20m", "1h"）
#     # 省略時: デフォルトのタイムアウト値を使用
#     delete = "20m"
#   }
# }

#-----------------------------------------------------------------------
# Attributes Reference
#-----------------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id - リソースID（domain_name と同じ値）
# - region - リソースが管理されているAWSリージョン
