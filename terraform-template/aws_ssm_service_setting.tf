#---------------------------------------------------------------
# AWS SSM Service Setting
#---------------------------------------------------------------
#
# AWS Systems Managerのサービス設定を管理するリソースです。
# サービス設定は、AWSサービスの機能の使い方やユーザーとの対話方法を定義する
# アカウントレベルの設定です。既存のSettingIdのデフォルト値を上書きすることで、
# サービスの動作をカスタマイズできます。
#
# AWS公式ドキュメント:
#   - Systems Manager概要: https://docs.aws.amazon.com/systems-manager/latest/userguide/what-is-systems-manager.html
#   - ServiceSetting API: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_ServiceSetting.html
#   - GetServiceSetting API: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_GetServiceSetting.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_service_setting
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssm_service_setting" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # setting_id (Required)
  # 設定内容: サービス設定のIDを指定します。
  # 設定可能な値:
  #   - "/ssm/appmanager/appmanager-enabled": App Managerの有効化
  #   - "/ssm/automation/customer-script-log-destination": Automationスクリプトのログ出力先
  #   - "/ssm/automation/customer-script-log-group-name": Automationスクリプトのロググループ名
  #   - "/ssm/automation/enable-adaptive-concurrency": Automation適応型同時実行の有効化
  #   - "/ssm/documents/console/public-sharing-permission": SSMドキュメントのパブリック共有権限
  #   - "/ssm/managed-instance/activation-tier": マネージドインスタンスのアクティベーション層
  #   - "/ssm/managed-instance/default-ec2-instance-management-role": デフォルトEC2インスタンス管理ロール
  #   - "/ssm/opsinsights/opscenter": OpsCenter OpsInsightsの有効化
  #   - "/ssm/parameter-store/default-parameter-tier": Parameter Storeのデフォルトパラメータ層
  #   - "/ssm/parameter-store/high-throughput-enabled": Parameter Storeの高スループットの有効化
  # 注意: setting_idはARN形式で指定します（例: arn:aws:ssm:us-east-1:123456789012:servicesetting/ssm/parameter-store/high-throughput-enabled）
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_GetServiceSetting.html#API_GetServiceSetting_RequestSyntax
  setting_id = "arn:aws:ssm:ap-northeast-1:123456789012:servicesetting/ssm/parameter-store/high-throughput-enabled"

  # setting_value (Required)
  # 設定内容: サービス設定の値を指定します。
  # 設定可能な値: 対象のsetting_idに応じた文字列値
  #   - high-throughput-enabled の場合: "true" または "false"
  #   - default-parameter-tier の場合: "Standard", "Advanced", "Intelligent-Tiering"
  #   - activation-tier の場合: "standard" または "advanced"
  #   - public-sharing-permission の場合: "Enable" または "Disable"
  # 注意: 設定可能な値はsetting_idによって異なります
  setting_value = "true"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: サービス設定のAmazon Resource Name (ARN)
#
# - status: サービス設定のステータス。
#           値は "Default"（デフォルト値のまま）、"Customized"（カスタマイズ済み）、
#           または "PendingUpdate"（更新保留中）のいずれかです。
#---------------------------------------------------------------
