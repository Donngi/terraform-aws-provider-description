#---------------------------------------------------------------
# AWS Organizations Organization
#---------------------------------------------------------------
#
# AWS Organizationsの組織をプロビジョニングするリソースです。
# 組織は複数のAWSアカウントを一元管理するための仕組みであり、
# 統合請求・サービスコントロールポリシー・AWSサービス統合などの
# 機能を提供します。
#
# AWS公式ドキュメント:
#   - AWS Organizations概要: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html
#   - 組織の全機能の有効化: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_org_support-all-features.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organization
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_organizations_organization" "example" {
  #-------------------------------------------------------------
  # 機能セット設定
  #-------------------------------------------------------------

  # feature_set (Optional)
  # 設定内容: 組織で有効にする機能セットを指定します。
  # 設定可能な値:
  #   - "ALL" (デフォルト): 全機能を有効化。サービスコントロールポリシー（SCP）や
  #     AWSサービス統合など全ての機能が使用可能になります。
  #   - "CONSOLIDATED_BILLING": 統合請求機能のみ有効化。
  # 注意: "CONSOLIDATED_BILLING"から"ALL"へ移行する場合、招待で参加したメンバー
  #       アカウントのオーナーが変更を承認する必要があります。承認後にAWSコンソールで
  #       移行を完了させる必要があります。完了まではTerraformが差分を検出し続けます。
  # 参考: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_org_support-all-features.html
  feature_set = "ALL"

  #-------------------------------------------------------------
  # AWSサービス統合設定
  #-------------------------------------------------------------

  # aws_service_access_principals (Optional)
  # 設定内容: 組織と統合を有効にするAWSサービスのプリンシパル名のリストを指定します。
  # 設定可能な値: AWSサービスのプリンシパル名（例: "cloudtrail.amazonaws.com"）のセット
  # 省略時: AWSサービス統合は無効
  # 注意: feature_setが"ALL"の場合のみ設定可能です。
  #       サービスによっては、このエンドポイント経由での有効化をサポートしていません。
  #       AWSのドキュメントの警告を参照してください。
  # 参考: https://docs.aws.amazon.com/organizations/latest/APIReference/API_EnableAWSServiceAccess.html
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
  ]

  #-------------------------------------------------------------
  # ポリシータイプ設定
  #-------------------------------------------------------------

  # enabled_policy_types (Optional)
  # 設定内容: 組織のルートで有効にするOrganizationsポリシータイプのリストを指定します。
  # 設定可能な値:
  #   - "AISERVICES_OPT_OUT_POLICY": AIサービスのオプトアウトポリシー
  #   - "BACKUP_POLICY": AWS Backupポリシー
  #   - "BEDROCK_POLICY": Amazon Bedrockポリシー
  #   - "CHATBOT_POLICY": AWS Chatbotポリシー
  #   - "DECLARATIVE_POLICY_EC2": EC2宣言型ポリシー
  #   - "INSPECTOR_POLICY": Amazon Inspectorポリシー（要: aws_service_access_principalsに"inspector2.amazonaws.com"）
  #   - "RESOURCE_CONTROL_POLICY": リソースコントロールポリシー
  #   - "S3_POLICY": Amazon S3ポリシー
  #   - "SECURITYHUB_POLICY": AWS Security Hubポリシー（要: aws_service_access_principalsに"securityhub.amazonaws.com"）
  #   - "SERVICE_CONTROL_POLICY": サービスコントロールポリシー（SCP）
  #   - "TAG_POLICY": タグポリシー
  #   - "UPGRADE_ROLLOUT_POLICY": アップグレードロールアウトポリシー
  # 省略時: ポリシータイプは有効化されません
  # 注意: feature_setが"ALL"の場合のみ設定可能です。
  # 参考: https://docs.aws.amazon.com/organizations/latest/APIReference/API_EnablePolicyType.html
  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
    "TAG_POLICY",
  ]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 組織のARN
# - id: 組織の識別子
# - master_account_arn: マスターアカウントのARN
# - master_account_email: マスターアカウントのメールアドレス
# - master_account_id: マスターアカウントの識別子
# - master_account_name: マスターアカウントの名前
# - accounts: マスターアカウントを含む全アカウントのリスト。
#             各要素: arn, email, id, joined_method, joined_timestamp, name, state
# - non_master_accounts: マスターアカウントを除く全アカウントのリスト。
#                        各要素: arn, email, id, joined_method, joined_timestamp, name, state
# - roots: 組織のルートのリスト。
#          各要素: arn, id, name, policy_types（status, type を持つオブジェクトのリスト）
#---------------------------------------------------------------
