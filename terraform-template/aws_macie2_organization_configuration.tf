#---------------------------------------------------------------
# Amazon Macie 組織設定
#---------------------------------------------------------------
#
# AWS Organizations と統合された Amazon Macie の組織設定を管理するリソースです。
# 委任された Macie 管理者アカウントが、組織に新規追加されるアカウントに対して
# Amazon Macie を自動的に有効化するかどうかを制御します。
#
# 前提条件:
#   - AWS Organizations が有効であること
#   - 委任された Macie 管理者アカウントが設定済みであること
#   - aws_macie2_account リソースで Macie が有効化済みであること
#
# AWS公式ドキュメント:
#   - 組織の統合と設定: https://docs.aws.amazon.com/macie/latest/user/accounts-mgmt-ao-integrate.html
#   - AWS Organizations との統合: https://docs.aws.amazon.com/macie/latest/user/accounts-mgmt-ao.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/macie2_organization_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_macie2_organization_configuration" "example" {
  #-------------------------------------------------------------
  # 自動有効化設定
  #-------------------------------------------------------------

  # auto_enable (Required)
  # 設定内容: AWS Organizations に追加されたアカウントに対して Amazon Macie を
  #           自動的に有効化するかどうかを指定します。
  # 設定可能な値:
  #   - true: 組織に新規追加されたアカウントに対して自動的に Macie を有効化し、
  #           委任管理者アカウントのメンバーとして関連付けます
  #   - false: 自動有効化を無効化。既存および新規アカウントを手動で追加する必要があります
  # 参考: https://docs.aws.amazon.com/macie/latest/user/accounts-mgmt-ao-integrate.html
  auto_enable = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: このリソースの識別子（AWS アカウント ID）
#---------------------------------------------------------------
