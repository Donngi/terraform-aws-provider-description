#---------------------------------------------------------------
# AWS OpenSearch Domain Policy
#---------------------------------------------------------------
#
# Amazon OpenSearch ServiceのドメインにIAMリソースベースアクセスポリシーを
# アタッチするリソースです。ドメインARNを参照しながらポリシーを設定できます。
# リソースベースポリシーはドメインのサブリソース（インデックス・APIなど）に
# 対してどのプリンシパルがどのアクションを実行できるかを制御します。
#
# AWS公式ドキュメント:
#   - OpenSearch Service アクセス制御概要: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/ac.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_opensearch_domain_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # domain_name (Required)
  # 設定内容: アクセスポリシーを適用するOpenSearchドメインの名前を指定します。
  # 設定可能な値: 既存のOpenSearchドメイン名（文字列）
  domain_name = "example-domain"

  # access_policies (Required)
  # 設定内容: ドメインに適用するIAMアクセスポリシードキュメントをJSON文字列で指定します。
  # 設定可能な値: JSON形式のIAMポリシードキュメント文字列
  # 注意: aws_iam_policy_documentデータソースを使用してJSON文字列を生成することを推奨します。
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/ac.html
  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action   = ["es:*"]
        Resource = "arn:aws:es:ap-northeast-1:123456789012:domain/example-domain/*"
        Condition = {
          IpAddress = {
            "aws:SourceIp" = ["203.0.113.0/24"]
          }
        }
      }
    ]
  })

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # update (Optional)
    # 設定内容: アクセスポリシーの更新操作がタイムアウトするまでの待機時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "60m", "2h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    update = "60m"

    # delete (Optional)
    # 設定内容: アクセスポリシーの削除操作がタイムアウトするまでの待機時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "60m", "2h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    delete = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ドメイン名（domain_nameと同値）
#---------------------------------------------------------------
