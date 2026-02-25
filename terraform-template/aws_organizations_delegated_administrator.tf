#---------------------------------------------------------------
# AWS Organizations Delegated Administrator
#---------------------------------------------------------------
#
# AWS Organizations の委任管理者（Delegated Administrator）をプロビジョニングする
# リソースです。指定したメンバーアカウントを特定の AWS サービスの委任管理者として
# 登録し、そのサービスに関する管理操作を組織の管理アカウントの代わりに実行できる
# ようにします。
#
# AWS公式ドキュメント:
#   - 委任管理者の概要: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_integrate_delegated_admin.html
#   - RegisterDelegatedAdministrator API: https://docs.aws.amazon.com/organizations/latest/APIReference/API_RegisterDelegatedAdministrator.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_delegated_administrator
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_organizations_delegated_administrator" "example" {
  #-------------------------------------------------------------
  # 委任先アカウント設定
  #-------------------------------------------------------------

  # account_id (Required)
  # 設定内容: 委任管理者として登録するメンバーアカウントの ID を指定します。
  # 設定可能な値: 12桁の AWS アカウント ID（例: "123456789012"）
  # 注意: 指定するアカウントは同じ AWS Organizations 組織のメンバーである必要があります。
  #       管理アカウント自身は委任管理者として登録できません。
  account_id = "123456789012"

  #-------------------------------------------------------------
  # サービスプリンシパル設定
  #-------------------------------------------------------------

  # service_principal (Required)
  # 設定内容: 委任管理者を登録する AWS サービスのサービスプリンシパルを指定します。
  # 設定可能な値: 対応する AWS サービスのサービスプリンシパル文字列。以下は主な例:
  #   - "config.amazonaws.com": AWS Config
  #   - "config-multiaccountsetup.amazonaws.com": AWS Config マルチアカウントセットアップ
  #   - "securityhub.amazonaws.com": AWS Security Hub
  #   - "guardduty.amazonaws.com": Amazon GuardDuty
  #   - "macie.amazonaws.com": Amazon Macie
  #   - "inspector2.amazonaws.com": Amazon Inspector
  #   - "access-analyzer.amazonaws.com": AWS IAM Access Analyzer
  #   - "account.amazonaws.com": AWS Account Management
  #   - "sso.amazonaws.com": AWS IAM Identity Center (旧 SSO)
  #   - "ram.amazonaws.com": AWS Resource Access Manager
  #   - "fms.amazonaws.com": AWS Firewall Manager
  #   - "audit-manager.amazonaws.com": AWS Audit Manager
  #   - "ipam.amazonaws.com": Amazon VPC IP Address Manager
  #   - "malware-protection.guardduty.amazonaws.com": Amazon GuardDuty マルウェア保護
  # 参考: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_integrate_services_list.html
  service_principal = "config.amazonaws.com"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 委任管理者の一意識別子（account_id と service_principal の組み合わせ）
# - arn: 委任管理者アカウントの Amazon Resource Name (ARN)
# - delegation_enabled_date: アカウントが委任管理者として登録された日時
# - email: 委任管理者の AWS アカウントに関連付けられたメールアドレス
# - joined_method: 委任管理者アカウントが組織に参加した方法
# - joined_timestamp: 委任管理者アカウントが組織のメンバーになった日時
# - name: 委任管理者アカウントのフレンドリー名
# - status: 組織内の委任管理者アカウントのステータス
#---------------------------------------------------------------
