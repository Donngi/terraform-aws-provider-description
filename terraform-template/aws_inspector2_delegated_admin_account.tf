#---------------------------------------------------------------
# AWS Inspector2 Delegated Admin Account
#---------------------------------------------------------------
#
# AWS Inspector2の委任管理者アカウントをプロビジョニングするリソースです。
# AWS Organizationsで利用する際に、Inspector2の管理を別のメンバーアカウントへ
# 委任することができます。委任管理者アカウントはOrganization全体の
# Inspector2スキャン設定や検出結果の管理を一元的に行う権限を持ちます。
#
# 前提条件:
#   - このリソースはOrganizationsの管理アカウントから実行する必要があります
#   - 委任先アカウントはOrganizationのメンバーアカウントである必要があります
#   - Inspector2がOrganization管理アカウントで有効化されている必要があります
#
# AWS公式ドキュメント:
#   - Amazon Inspector概要: https://docs.aws.amazon.com/inspector/latest/user/what-is-inspector.html
#   - 委任管理者の設定: https://docs.aws.amazon.com/inspector/latest/user/designate-a-delegated-admin-account.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector2_delegated_admin_account
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_inspector2_delegated_admin_account" "example" {
  #-------------------------------------------------------------
  # 委任管理者設定
  #-------------------------------------------------------------

  # account_id (Required)
  # 設定内容: Inspector2の管理を委任するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID（Organizationのメンバーアカウント）
  # 注意: Organizationsの管理アカウントから実行する必要があります
  account_id = "111222333444"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "15m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "15m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - relationship_status: 委任管理者とOrganization管理アカウントの
#                        関係ステータス（例: "ENABLED"）
#---------------------------------------------------------------

#---------------------------------------------------------------
# 運用上の注意事項
#---------------------------------------------------------------
# 1. Organizationsの前提条件
#    - AWS Organizationsが有効化されていることが必要です
#    - このリソースはOrganizationsの管理アカウントから実行してください
#
# 2. 委任管理者の制限
#    - 各リージョンに設定できる委任管理者は1アカウントのみです
#    - 委任管理者を変更するには、既存の設定を削除してから再設定が必要です
#
# 3. Inspector2との連携
#    - aws_inspector2_enabler リソースと組み合わせて使用することで、
#      Organization全体のInspector2を一元管理できます
#---------------------------------------------------------------
