#---------------------------------------------------------------
# AWS QuickSight Account Settings
#---------------------------------------------------------------
#
# Amazon QuickSightアカウントの設定を管理するリソースです。
# アカウントの削除保護（終了保護）やデフォルトネームスペースなどの
# アカウントレベルの設定を構成します。
#
# 注意: このリソースを削除（terraform destroy）しても、実際のQuickSight
#       アカウント設定は変更されず、Terraformのステートから除外されるのみです。
#
# AWS公式ドキュメント:
#   - AccountSettings APIリファレンス: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_AccountSettings.html
#   - UpdateAccountSettings APIリファレンス: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_UpdateAccountSettings.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_account_settings
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_account_settings" "example" {
  #-------------------------------------------------------------
  # アカウント識別設定
  #-------------------------------------------------------------

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: 設定対象のAWSアカウントIDを指定します。
  # 設定可能な値: 有効な12桁のAWSアカウントID
  # 省略時: Terraform AWSプロバイダーが自動的に判定したアカウントIDを使用します。
  aws_account_id = null

  #-------------------------------------------------------------
  # ネームスペース設定
  #-------------------------------------------------------------

  # default_namespace (Optional)
  # 設定内容: このAWSアカウントのデフォルトQuickSightネームスペースを指定します。
  # 設定可能な値: 最大64文字の英数字、ハイフン、アンダースコアで構成される文字列
  # 省略時: "default" ネームスペースが使用されます。
  # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_AccountSettings.html
  default_namespace = "default"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 削除保護設定
  #-------------------------------------------------------------

  # termination_protection_enabled (Optional)
  # 設定内容: Amazon QuickSightアカウントの削除を禁止する終了保護を有効にするかを指定します。
  # 設定可能な値:
  #   - true: 終了保護を有効化。DeleteAccountSubscription リクエスト時にエラーが発生し
  #           アカウントを削除できなくなります。
  #   - false: 終了保護を無効化。アカウントの削除が可能になります。
  # 省略時: false
  # 注意: アカウントを削除する前にこの値を false に変更する必要があります。
  #       アカウント削除は不可逆的な操作であり、全リージョンの全データが削除されます。
  # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_DeleteAccountSubscription.html
  termination_protection_enabled = false

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" 等、数値と単位（s/m/h）で構成される文字列
    # 省略時: デフォルトのタイムアウト時間が適用されます。
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" 等、数値と単位（s/m/h）で構成される文字列
    # 省略時: デフォルトのタイムアウト時間が適用されます。
    update = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースのID（aws_account_id と同一の値）
#---------------------------------------------------------------
