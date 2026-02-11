# =============================================================================
# Terraform Resource: aws_elasticsearch_domain_policy
# =============================================================================
# Generated: 2026-01-23
# Provider Version: hashicorp/aws 6.28.0
#
# 注意事項:
# - このテンプレートは生成時点（2026-01-23）の AWS Provider 6.28.0 の仕様に基づいています
# - 最新の仕様や詳細については、必ず公式ドキュメントをご確認ください
# - Elasticsearch Service は Amazon OpenSearch Service に移行されています
#   新規プロジェクトでは aws_opensearch_domain_policy の使用を検討してください
#
# 参考:
# - Terraform AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/elasticsearch_domain_policy
# - AWS OpenSearch Service Access Control: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/ac.html
# =============================================================================

resource "aws_elasticsearch_domain_policy" "example" {
  # -------------------------------------------------------------------------
  # Required Arguments
  # -------------------------------------------------------------------------

  # domain_name - (Required) Elasticsearchドメインの名前
  # 既存のElasticsearchドメインに対してポリシーを適用する際に使用
  # aws_elasticsearch_domain リソースの domain_name 属性を参照することが推奨される
  # Type: string
  domain_name = "example-domain"

  # access_policies - (Required) ドメインへのアクセスポリシーを定義するIAMポリシードキュメント
  # JSON形式のIAMポリシーで、以下を制御:
  # - どのプリンシパル（IAMユーザー、ロール、AWSアカウント）がアクセス可能か
  # - どのアクション（es:*、es:ESHttpGet、es:ESHttpPutなど）を許可/拒否するか
  # - どのリソース（ドメイン全体、特定のインデックスなど）に対して
  # - どの条件（IPアドレス、VPC、時刻など）で
  #
  # ポリシーの種類:
  # - リソースベースポリシー: ドメインに付与され、Principal要素を含む
  # - IPベースポリシー: Condition要素でIPアドレスやCIDRブロックを指定
  # - VPCベースポリシー: VPC内からのアクセスを制御
  #
  # 注意:
  # - ポリシーの競合時は、最も具体的なポリシーが優先される
  # - 明示的なDenyは常にAllowを上書きする
  # - 明示的な許可がない場合、デフォルトで拒否される
  #
  # 参考:
  # - IAM Policy Elements: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements.html
  # - OpenSearch Service Access Control: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/ac.html
  # Type: string (JSON)
  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action   = "es:*"
        Resource = "arn:aws:es:us-east-1:123456789012:domain/example-domain/*"
        Condition = {
          IpAddress = {
            "aws:SourceIp" = ["203.0.113.0/24"]
          }
        }
      }
    ]
  })

  # -------------------------------------------------------------------------
  # Optional Arguments
  # -------------------------------------------------------------------------

  # region - (Optional) このリソースを管理するAWSリージョン
  # 指定しない場合、プロバイダー設定のリージョンが使用される
  # マルチリージョン構成の場合に明示的に指定可能
  #
  # 参考:
  # - AWS Regional Endpoints: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # - Provider Configuration: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  # Type: string
  # region = "us-east-1"

  # -------------------------------------------------------------------------
  # Timeouts Block (Optional)
  # -------------------------------------------------------------------------
  # リソース操作のタイムアウト時間をカスタマイズ可能

  timeouts {
    # update - (Optional) ポリシーの更新操作のタイムアウト
    # デフォルト: 5分
    # 大規模なドメインや複雑なポリシーの場合、より長い時間が必要な場合がある
    # 形式: "5m", "1h", "30s" など
    # update = "10m"

    # delete - (Optional) ポリシーの削除操作のタイムアウト
    # デフォルト: 5分
    # ポリシー削除後のリソースのクリーンアップ時間を考慮
    # 形式: "5m", "1h", "30s" など
    # delete = "10m"
  }
}

# =============================================================================
# Computed Attributes (Read-Only)
# =============================================================================
# 以下の属性は自動的に計算され、読み取り専用です。テンプレートには記載しません。
#
# - id: リソースの一意な識別子（domain_nameと同じ値）
#      Type: string
#      使用例: aws_elasticsearch_domain_policy.example.id
#
# =============================================================================
# 使用例
# =============================================================================
#
# 1. 基本的な使用例（IPアドレス制限付き）:
#
# resource "aws_elasticsearch_domain" "example" {
#   domain_name           = "example-domain"
#   elasticsearch_version = "7.10"
# }
#
# resource "aws_elasticsearch_domain_policy" "example" {
#   domain_name = aws_elasticsearch_domain.example.domain_name
#
#   access_policies = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           AWS = "*"
#         }
#         Action   = "es:*"
#         Resource = "$${aws_elasticsearch_domain.example.arn}/*"
#         Condition = {
#           IpAddress = {
#             "aws:SourceIp" = "127.0.0.1/32"
#           }
#         }
#       }
#     ]
#   })
# }
#
# 2. 特定のIAMロールへのアクセス許可:
#
# resource "aws_elasticsearch_domain_policy" "example" {
#   domain_name = aws_elasticsearch_domain.example.domain_name
#
#   access_policies = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::123456789012:role/my-application-role"
#         }
#         Action = [
#           "es:ESHttpGet",
#           "es:ESHttpPost",
#           "es:ESHttpPut"
#         ]
#         Resource = "$${aws_elasticsearch_domain.example.arn}/*"
#       }
#     ]
#   })
# }
#
# 3. VPCエンドポイントからのアクセスのみ許可:
#
# resource "aws_elasticsearch_domain_policy" "example" {
#   domain_name = aws_elasticsearch_domain.example.domain_name
#
#   access_policies = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           AWS = "*"
#         }
#         Action   = "es:*"
#         Resource = "$${aws_elasticsearch_domain.example.arn}/*"
#         Condition = {
#           StringEquals = {
#             "aws:SourceVpce" = "vpce-1234567890abcdef0"
#           }
#         }
#       }
#     ]
#   })
# }
#
# =============================================================================
