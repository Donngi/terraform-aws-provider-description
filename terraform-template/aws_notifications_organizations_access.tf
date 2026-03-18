#---------------------------------------------------------------
# AWS User Notifications - Organizations Access (Organizations アクセス)
#---------------------------------------------------------------
#
# AWS User Notifications の AWS Organizations アクセスを管理するリソースです。
# このリソースを使用して、AWS User Notifications が AWS Organizations の
# 組織情報にアクセスする権限を有効化または無効化できます。
# Organizations アクセスを有効にすることで、組織全体の通知管理が可能になります。
#
# 注意事項:
#   - このリソースは AWS Organizations の管理アカウントでのみ使用できます。
#   - このリソースを削除すると、enabled 属性の値に関わらず
#     Organizations アクセスは常に無効化されます。
#
# AWS公式ドキュメント:
#   - AWS User Notifications: https://docs.aws.amazon.com/notifications/latest/userguide/what-is-notifications.html
#   - Organizations との統合: https://docs.aws.amazon.com/notifications/latest/userguide/organizations-integration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/notifications_organizations_access
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_notifications_organizations_access" "example" {
  #-------------------------------------------------------------
  # Organizations アクセス設定
  #-------------------------------------------------------------

  # enabled (Required)
  # 設定内容: AWS User Notifications の AWS Organizations アクセスを
  #           有効化するかどうかを指定します。
  #           true に設定すると Organizations アクセスが有効化され、
  #           組織全体の通知管理機能が利用可能になります。
  #           false に設定すると Organizations アクセスが無効化されます。
  # 設定可能な値: true / false
  enabled = true

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定します。
  timeouts {
    # create (Optional)
    # 設定内容: Organizations アクセスの有効化操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" など Go の time.ParseDuration が解析できる文字列
    # 省略時: プロバイダーのデフォルト値が使用されます
    create = "30m"

    # update (Optional)
    # 設定内容: Organizations アクセスの更新操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" など Go の time.ParseDuration が解析できる文字列
    # 省略時: プロバイダーのデフォルト値が使用されます
    update = "30m"

    # delete (Optional)
    # 設定内容: Organizations アクセスの無効化（削除）操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" など Go の time.ParseDuration が解析できる文字列
    # 省略時: プロバイダーのデフォルト値が使用されます
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - enabled: Organizations アクセスの有効/無効状態
#---------------------------------------------------------------
