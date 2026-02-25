#---------------------------------------------------------------
# AWS Organizations Policy
#---------------------------------------------------------------
#
# AWS Organizationsのポリシーをプロビジョニングするリソースです。
# サービスコントロールポリシー（SCP）、タグポリシー、バックアップポリシー、
# AIサービスオプトアウトポリシーなど、複数種類のポリシーを作成・管理できます。
# ポリシーはアカウント、OU（組織単位）、またはルートにアタッチして使用します。
#
# AWS公式ドキュメント:
#   - AWS Organizations ポリシー管理: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies.html
#   - サービスコントロールポリシー（SCP）: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scp.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_organizations_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ポリシーに割り当てるフレンドリー名を指定します。
  # 設定可能な値: 文字列（AWS Organizationsのポリシー名として有効な文字列）
  name = "example-policy"

  # content (Required)
  # 設定内容: ポリシーに追加するポリシーコンテンツ（JSON形式）を指定します。
  #           ポリシータイプに応じて異なる構文が要求されます。
  # 設定可能な値: JSON文字列。ポリシータイプ別の構文仕様に従う必要があります。
  #   - SCP: アカウントの委任権限を指定するJSON
  #     https://docs.aws.amazon.com/organizations/latest/userguide/orgs_reference_scp-syntax.html
  #   - タグポリシー: タグ付けルールを定義するJSON
  #     https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_example-tag-policies.html
  #   - バックアップポリシー: バックアップ計画を指定するJSON
  #     https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_backup_syntax.html
  #   - AIサービスオプトアウトポリシー: AIサービスのオプトアウトを指定するJSON
  #     https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_ai-opt-out_syntax.html
  #   - RCP（リソースコントロールポリシー）: リソースアクセスを制御するJSON
  #     https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_rcps_syntax.html
  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "*"
        Resource  = "*"
      }
    ]
  })

  #-------------------------------------------------------------
  # ポリシータイプ設定
  #-------------------------------------------------------------

  # type (Optional)
  # 設定内容: 作成するポリシーの種類を指定します。
  # 設定可能な値:
  #   - "SERVICE_CONTROL_POLICY" (デフォルト): サービスコントロールポリシー（SCP）
  #     アカウント内でユーザーやロールが実行できるアクションを制限します。
  #   - "TAG_POLICY": タグポリシー。アカウント全体のリソースタグ付けを標準化します。
  #   - "BACKUP_POLICY": バックアップポリシー。AWS Backupの設定を一元管理します。
  #   - "AISERVICES_OPT_OUT_POLICY": AIサービスオプトアウトポリシー。
  #     AWSのAIサービスによるコンテンツ利用をオプトアウトします。
  #   - "RESOURCE_CONTROL_POLICY": リソースコントロールポリシー（RCP）。
  #     リソースへのアクセスを制御します。
  #   - "BEDROCK_POLICY": Amazon Bedrockポリシー。
  #   - "CHATBOT_POLICY": AWS Chatbotポリシー。
  #   - "DECLARATIVE_POLICY_EC2": EC2宣言型ポリシー。
  #   - "INSPECTOR_POLICY": Amazon Inspectorポリシー。
  #   - "S3_POLICY": Amazon S3ポリシー。
  #   - "SECURITYHUB_POLICY": AWS Security Hubポリシー。
  #   - "UPGRADE_ROLLOUT_POLICY": アップグレードロールアウトポリシー。
  # 省略時: "SERVICE_CONTROL_POLICY"
  # 注意: ポリシータイプによってcontentに記述するJSON構文が異なります。
  #       また、各ポリシータイプを使用するには事前にOrganizationsで有効化が必要です。
  type = "SERVICE_CONTROL_POLICY"

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: ポリシーに割り当てる説明文を指定します。
  # 設定可能な値: 文字列
  # 省略時: 説明なし
  description = "Example organizations policy"

  #-------------------------------------------------------------
  # ライフサイクル設定
  #-------------------------------------------------------------

  # skip_destroy (Optional)
  # 設定内容: terraform destroy実行時にポリシーを削除せず、stateからのみ削除するかを指定します。
  # 設定可能な値:
  #   - true: destroyでもポリシーを削除しない（stateからのみ削除）
  #   - false (デフォルト): destroyでポリシーを削除する
  # 省略時: false
  # 用途: AWSのOrganizationsポリシー要件として最低1つのポリシーがアタッチされている必要がある
  #       場合に、ポリシーとそのアタッチメントを保持するために使用します。
  skip_destroy = false

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
    Name        = "example-policy"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ポリシーの一意識別子（ID）
#
# - arn: ポリシーのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
