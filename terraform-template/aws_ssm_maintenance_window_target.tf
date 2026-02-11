#---------------------------------------------------------------
# AWS Systems Manager Maintenance Window Target
#---------------------------------------------------------------
#
# AWS Systems Manager Maintenance Windowのターゲットをプロビジョニングするリソースです。
# Maintenance Windowは、AWS リソースに対して破壊的なアクション（OSのパッチ適用や
# ソフトウェアのインストールなど）をスケジュールするために使用されるツールです。
# このリソースは、Maintenance Windowがアクションを実行する対象（インスタンスや
# リソースグループなど）を登録します。
#
# AWS公式ドキュメント:
#   - Maintenance Windows概要: https://docs.aws.amazon.com/systems-manager/latest/userguide/maintenance-windows.html
#   - ターゲットの割り当て: https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-maintenance-assign-targets.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_maintenance_window_target
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssm_maintenance_window_target" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # window_id (Required)
  # 設定内容: ターゲットを登録するMaintenance WindowのIDを指定します。
  # 設定可能な値: 有効なMaintenance Window ID
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/userguide/maintenance-windows.html
  window_id = "mw-0123456789abcdef0"

  # resource_type (Required)
  # 設定内容: Maintenance Windowに登録するターゲットのタイプを指定します。
  # 設定可能な値:
  #   - "INSTANCE": EC2インスタンスを対象とする
  #   - "RESOURCE_GROUP": リソースグループを対象とする
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-maintenance-assign-targets.html
  resource_type = "INSTANCE"

  #-------------------------------------------------------------
  # 識別情報設定
  #-------------------------------------------------------------

  # name (Optional)
  # 設定内容: Maintenance Window ターゲットの名前を指定します。
  # 設定可能な値: 文字列（最小3文字、最大128文字）
  # 省略時: 名前なしで登録されます
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_MaintenanceWindowTarget.html
  name = "maintenance-window-target"

  # description (Optional)
  # 設定内容: Maintenance Window ターゲットの説明を指定します。
  # 設定可能な値: 文字列（最大128文字）
  # 省略時: 説明なしで登録されます
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_MaintenanceWindowTarget.html
  description = "This is a maintenance window target"

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
  # イベント情報設定
  #-------------------------------------------------------------

  # owner_information (Optional)
  # 設定内容: このMaintenance Windowでこれらのターゲットに対してタスクを実行している間に
  #          発生するAmazon EventBridgeイベントに含まれるユーザー提供の値を指定します。
  # 設定可能な値: 文字列（最大128文字）
  # 省略時: EventBridgeイベントに含まれません
  # 関連機能: Amazon EventBridgeとの統合
  #   Maintenance Window実行時のイベントをEventBridgeで監視する際に、
  #   このフィールドの値をイベントペイロードに含めることができます。
  #   - https://docs.aws.amazon.com/systems-manager/latest/userguide/monitoring-eventbridge-events.html
  owner_information = "Operations Team"

  #-------------------------------------------------------------
  # ターゲット指定設定
  #-------------------------------------------------------------

  # targets (Required, Min: 1, Max: 5)
  # 設定内容: Maintenance Windowに登録するターゲットを指定します。
  #          つまり、Maintenance Window実行時にコマンドを実行するインスタンスを指定します。
  # 設定可能な値: インスタンスID、リソースグループ名、またはインスタンスに適用されたタグで指定
  # 注意: 単一のMaintenance Windowタスクが複数のターゲットに登録されている場合、
  #      タスクの呼び出しは並列ではなく順次実行されます。
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/userguide/mw-cli-tutorial-targets-examples.html
  targets {
    # key (Required)
    # 設定内容: ターゲットを識別するためのキーを指定します。
    # 設定可能な値:
    #   - "InstanceIds": インスタンスIDで指定する場合
    #   - "tag:{TagKey}": タグで指定する場合（例: tag:Environment）
    #   - "resource-groups:ResourceTypeFilters": リソースグループのリソースタイプで指定する場合
    #   - "resource-groups:Name": リソースグループ名で指定する場合
    key = "tag:Environment"

    # values (Required)
    # 設定内容: keyに対応する値のリストを指定します。
    # 設定可能な値:
    #   - key が "InstanceIds" の場合: インスタンスIDのリスト（例: ["i-1234567890abcdef0"]）
    #   - key が "tag:{TagKey}" の場合: タグの値のリスト（例: ["production", "staging"]）
    #   - key が "resource-groups:ResourceTypeFilters" の場合: リソースタイプのリスト（例: ["AWS::EC2::Instance"]）
    #   - key が "resource-groups:Name" の場合: リソースグループ名のリスト
    values = ["production"]
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Maintenance Window ターゲットのID
#---------------------------------------------------------------
