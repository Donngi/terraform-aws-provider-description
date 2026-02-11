#---------------------------------------------------------------
# Amazon ECR Registry Policy
#---------------------------------------------------------------
#
# Amazon Elastic Container Registry (ECR) のプライベートレジストリに対して
# アクセス許可を付与するためのレジストリポリシーを管理します。
# レジストリポリシーは、リージョンレベルで適用され、クロスアカウント
# レプリケーションやPull Through Cache機能などに必要な権限を
# 他のAWSアカウントに付与するために使用されます。
#
# AWS公式ドキュメント:
#   - Private registry permissions in Amazon ECR: https://docs.aws.amazon.com/AmazonECR/latest/userguide/registry-permissions.html
#   - Private registry policy examples: https://docs.aws.amazon.com/AmazonECR/latest/userguide/registry-permissions-examples.html
#   - Granting registry permissions for cross account replication: https://docs.aws.amazon.com/AmazonECR/latest/userguide/registry-permissions-create-replication.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_registry_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-26
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 重要な注意事項
#---------------------------------------------------------------
# - AWS Management Consoleでは複数のポリシーステートメントを作成できる
#   ように見えますが、ECRレジストリポリシーはAWS APIレベルでは
#   リージョンごとに単一のエンティティとして管理されます。
# - そのため、aws_ecr_registry_policyリソースは1つのリージョンに
#   つき1つだけ設定し、必要なすべてのステートメントを同じポリシー内で
#   定義する必要があります。
# - 複数のaws_ecr_registry_policyリソースを定義すると、永続的な差分が
#   発生し、一方のポリシーが他方を上書きする可能性があります。
#---------------------------------------------------------------

resource "aws_ecr_registry_policy" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # (Required) レジストリポリシードキュメント（JSON形式）
  # IAMポリシードキュメントと同じ形式で、Version、Statement、Sid、Effect、
  # Principal、Action、Resourceを含みます。
  #
  # 主な用途:
  # - ecr:ReplicateImage: クロスアカウントレプリケーションを許可
  # - ecr:CreateRepository: レプリケーション時のリポジトリ自動作成を許可
  # - ecr:BatchImportUpstreamImage: Pull Through Cacheで外部イメージの
  #   インポートを許可
  #
  # ポリシースコープ:
  # - V1（バージョン1）: 上記の特定アクションのみを強制
  # - V2（バージョン2、デフォルト）: すべてのECRアクションを許可し、
  #   全ECRリクエストでレジストリポリシーを強制
  #
  # ベストプラクティス:
  # - ワイルドカード（ecr:*）ではなく、必要な特定のアクションのみを指定
  # - クロスアカウントレプリケーションには、ecr:ReplicateImageと
  #   ecr:CreateRepositoryの両方を含めることを推奨
  # - Principalでアカウント全体を指定すると、そのアカウント内の
  #   すべてのIAMユーザーとロールにアクセスが許可されます。
  #   より制限的なアクセスが必要な場合は、個別のIAMユーザー、ロール、
  #   または条件ステートメントを使用してください。
  #
  # 参考: https://learn.hashicorp.com/terraform/aws/iam-policy
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCrossAccountReplication"
        Effect = "Allow"
        Principal = {
          "AWS" : "arn:aws:iam::123456789012:root"
        }
        Action = [
          "ecr:ReplicateImage",
          "ecr:CreateRepository"
        ]
        Resource = "arn:aws:ecr:us-east-1:111111111111:repository/*"
      }
    ]
  })

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # (Optional) このリソースが管理されるAWSリージョン
  # 指定しない場合は、プロバイダー設定のリージョンが使用されます。
  # レジストリポリシーはリージョンごとに個別に設定されるため、
  # マルチリージョン環境では、各リージョンで個別のリソースを定義する
  # 必要があります。
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # (Optional) Terraform管理用のリソースID
  # 通常は自動的に計算されるため、明示的に設定する必要はありません。
  # このパラメータはcomputed属性でもあるため、値を指定しない場合は
  # Terraformが自動的に設定します。
  # id = "custom-id"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースでは以下の属性が参照可能です（computed only）:
#
# - registry_id: レジストリが作成されたAWSアカウントID（レジストリID）
#   例: aws_ecr_registry_policy.example.registry_id
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のECRレジストリポリシーは、レジストリIDを使用してインポート
# できます。通常、レジストリIDはAWSアカウントIDと同じです。
#
# 例:
# terraform import aws_ecr_registry_policy.example 123456789012
#---------------------------------------------------------------

