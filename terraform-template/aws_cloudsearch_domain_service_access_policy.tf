# ================================================================================
# Terraform Resource Template: aws_cloudsearch_domain_service_access_policy
# ================================================================================
#
# Generated: 2026-01-18
# Provider Version: hashicorp/aws 6.28.0
#
# NOTE: このテンプレートは生成時点の情報です。
#       最新の仕様については公式ドキュメントを確認してください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudsearch_domain_service_access_policy
#
# ================================================================================

# aws_cloudsearch_domain_service_access_policy
#
# CloudSearchドメインのサービスアクセスポリシーを提供します。
# このリソースは、ドメインのドキュメントエンドポイントと検索エンドポイントへのアクセスを
# 制御するIAMポリシーを設定します。
#
# Terraformは設定適用時、ドメインサービスアクセスポリシーが `Active` 状態になるまで待機します。
#
# AWS公式ドキュメント:
# - CloudSearchアクセス設定: https://docs.aws.amazon.com/cloudsearch/latest/developerguide/configuring-access.html
# - UpdateServiceAccessPolicies API: https://docs.aws.amazon.com/cloudsearch/latest/developerguide/API_UpdateServiceAccessPolicies.html

resource "aws_cloudsearch_domain_service_access_policy" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # domain_name (required)
  # CloudSearchドメインの名前を指定します。
  # このポリシーが適用されるCloudSearchドメインを識別するための一意の文字列です。
  # 通常は `aws_cloudsearch_domain` リソースの `id` または `name` を参照します。
  #
  # 参照: https://docs.aws.amazon.com/cloudsearch/latest/developerguide/creating-domains.html
  domain_name = "example-domain"

  # access_policy (required)
  # ドメインへのアクセスを制御するIAMポリシードキュメント(JSON形式)を指定します。
  # このポリシーは既存のルールを完全に置き換えます。
  #
  # 設定可能な内容:
  # - IPアドレスベースのアクセス制限
  # - AWS アカウントベースのアクセス許可
  # - パブリックアクセスの許可/拒否
  # - 特定のCloudSearch API操作(search, document, suggest)への制限
  #
  # アクションの種類:
  # - cloudsearch:search - 検索サービスへのアクセス
  # - cloudsearch:document - ドキュメントサービスへのアクセス
  # - cloudsearch:suggest - サジェストサービスへのアクセス
  #
  # 最大サイズ: 100 KB
  #
  # 参照: https://docs.aws.amazon.com/cloudsearch/latest/developerguide/configuring-access.html
  access_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "search_only"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "cloudsearch:search",
          "cloudsearch:document"
        ]
        Condition = {
          IpAddress = {
            "aws:SourceIp" = ["192.0.2.0/32"]
          }
        }
      }
    ]
  })

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # region (optional)
  # このリソースを管理するAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  #
  # CloudSearchドメインは特定のリージョンに作成されるため、
  # 通常はプロバイダーのリージョン設定と一致させる必要があります。
  #
  # 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ============================================================================
  # Timeouts Configuration
  # ============================================================================

  # timeouts ブロック (optional)
  # リソース操作のタイムアウト設定を行います。
  # CloudSearchのサービスアクセスポリシー設定は、ドメインの状態によって時間がかかる場合があります。

  # timeouts {
  #   # update (optional)
  #   # ポリシー更新操作のタイムアウト時間を指定します。
  #   # デフォルト: 20m (20分)
  #   #
  #   # CloudSearchドメインがActive状態になるまでの時間を考慮して設定してください。
  #   update = "30m"
  #
  #   # delete (optional)
  #   # ポリシー削除操作のタイムアウト時間を指定します。
  #   # デフォルト: 20m (20分)
  #   delete = "30m"
  # }
}

# ================================================================================
# Attributes Reference (Computed)
# ================================================================================
#
# このリソースは以下の属性を公開します(読み取り専用):
#
# - id - リソースの一意識別子(通常はドメイン名と同じ)
#
# ================================================================================
# Import
# ================================================================================
#
# CloudSearchドメインサービスアクセスポリシーは、ドメイン名を使用してインポートできます:
#
# $ terraform import aws_cloudsearch_domain_service_access_policy.example example-domain
#
# ================================================================================
