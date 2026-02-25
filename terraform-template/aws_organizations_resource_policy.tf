#---------------------------------------------------------------
# AWS Organizations Resource Policy
#---------------------------------------------------------------
#
# AWS Organizations管理アカウントにリソースポリシーをプロビジョニングするリソースです。
# リソースポリシーを使用することで、組織管理外のAWSアカウントや組織メンバーアカウントに
# 対して、Organizationsリソースへのアクセス権限を委任できます。
# Organizations APIへのクロスアカウントアクセスを制御する際に使用します。
#
# AWS公式ドキュメント:
#   - AWS Organizations リソースポリシー: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_delegate_examples.html
#   - リソースポリシー構文リファレンス: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_reference_resource_policy_syntax.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_resource_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_organizations_resource_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # content (Required)
  # 設定内容: Organizations管理アカウントに適用するリソースポリシーのコンテンツ（JSON形式）を指定します。
  #           ポリシーはAWS Organizations APIへのクロスアカウントアクセスを制御します。
  # 設定可能な値: JSON文字列。IAMポリシーと同様の構文を使用します。
  #   - Effect: "Allow" または "Deny"
  #   - Principal: アクセスを許可/拒否するエンティティ（AWSアカウントIDまたはARN）
  #   - Action: 許可/拒否するOrganizations APIアクション
  #     例: "organizations:DescribeOrganization", "organizations:ListDelegatedAdministrators"
  #   - Resource: 適用対象リソース（通常は "*"）
  # 注意: ポリシーはOrganizations管理アカウントにのみ関連付けられます。
  #       リソースポリシーはOrganizationsの管理アカウントから操作を委任するために使用します。
  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowOrganizationsRead"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action = [
          "organizations:DescribeOrganization",
          "organizations:ListAccounts",
          "organizations:ListDelegatedAdministrators"
        ]
        Resource = "*"
      }
    ]
  })

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-organizations-resource-policy"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースポリシーの一意識別子（ID）
#
# - arn: リソースポリシーのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
