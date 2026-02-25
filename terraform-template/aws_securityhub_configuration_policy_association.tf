#---------------------------------------------------------------
# AWS Security Hub Configuration Policy Association
#---------------------------------------------------------------
#
# AWS Security Hubの設定ポリシーと対象（アカウント、組織単位、ルート）を
# 関連付けるリソースです。
# Security Hubの中央設定機能（Central Configuration）を使用して、
# 委任された管理者アカウントが組織内の複数のアカウントに対して
# 設定ポリシーを適用・管理します。
#
# 前提条件:
#   - aws_securityhub_organization_configuration で configuration_type = "CENTRAL" が必要
#
# AWS公式ドキュメント:
#   - 設定ポリシーの作成と関連付け: https://docs.aws.amazon.com/securityhub/latest/userguide/create-associate-policy.html
#   - 中央設定の概要: https://docs.aws.amazon.com/securityhub/latest/userguide/central-configuration-intro.html
#   - 集中管理と自己管理のターゲット: https://docs.aws.amazon.com/securityhub/latest/userguide/central-configuration-management-type.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_configuration_policy_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securityhub_configuration_policy_association" "example" {
  #-------------------------------------------------------------
  # ターゲット設定
  #-------------------------------------------------------------

  # target_id (Required, Forces new resource)
  # 設定内容: 設定ポリシーを関連付けるターゲットの識別子を指定します。
  # 設定可能な値:
  #   - AWSアカウントID（例: "123456789012"）: 特定アカウントへの関連付け
  #   - 組織単位ID（例: "ou-abcd-12345678"）: OUへの関連付け（配下のアカウントに継承）
  #   - ルートID（例: "r-abcd"）: 組織ルートへの関連付け（全アカウントに適用）
  # 注意: このパラメータを変更すると既存リソースが削除され再作成されます
  # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/central-configuration-intro.html
  target_id = "123456789012"

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy_id (Required)
  # 設定内容: ターゲットに関連付ける設定ポリシーのUUID（汎用一意識別子）を指定します。
  # 設定可能な値: aws_securityhub_configuration_policy リソースの id 属性など、
  #               有効な設定ポリシーのUUID文字列
  # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/create-associate-policy.html
  policy_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Goのduration文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルト値を使用
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: Goのduration文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルト値を使用
    update = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 設定に関連付けられたターゲットアカウント、組織単位、またはルートの識別子
#---------------------------------------------------------------
