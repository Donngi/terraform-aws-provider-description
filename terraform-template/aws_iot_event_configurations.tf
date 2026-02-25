#---------------------------------------------------------------
# AWS IoT Event Configurations
#---------------------------------------------------------------
#
# AWS IoTのイベント設定を管理するリソースです。
# デバイス、モノグループ、証明書、ジョブ、ポリシーなどの
# IoTエンティティに関するイベントの有効/無効をマップ形式で設定します。
#
# NOTE: このリソースを削除してもイベント設定は無効化されません。
#       Terraformのstateから削除されるのみで、AWSのイベント設定は維持されます。
#
# AWS公式ドキュメント:
#   - AWS IoT ライフサイクルイベント: https://docs.aws.amazon.com/iot/latest/developerguide/life-cycle-events.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_event_configurations
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_event_configurations" "example" {
  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # イベント設定
  #-------------------------------------------------------------

  # event_configurations (Required)
  # 設定内容: IoTイベントの有効/無効を設定するマップを指定します。
  #           各キーにbool値（true=有効、false=無効）を指定します。
  # 設定可能なキー:
  #   - "THING"                  : モノ（Thing）の作成・更新・削除イベント
  #   - "THING_GROUP"            : モノグループの作成・更新・削除イベント
  #   - "THING_TYPE"             : モノタイプの作成・更新・削除イベント
  #   - "THING_GROUP_MEMBERSHIP" : モノのグループへの追加・削除イベント
  #   - "THING_GROUP_HIERARCHY"  : グループ階層の変更イベント
  #   - "THING_TYPE_ASSOCIATION" : モノとモノタイプの関連付け・解除イベント
  #   - "JOB"                    : ジョブの作成・完了・削除イベント
  #   - "JOB_EXECUTION"          : ジョブ実行の状態変更イベント
  #   - "POLICY"                 : IoTポリシーの作成・更新・削除イベント
  #   - "CERTIFICATE"            : 証明書の作成・更新・削除イベント
  #   - "CA_CERTIFICATE"         : CA証明書の登録・更新・削除イベント
  # 注意: マップには上記11種類のキーのみ使用可能です。
  event_configurations = {
    "THING"                  = true
    "THING_GROUP"            = false
    "THING_TYPE"             = false
    "THING_GROUP_MEMBERSHIP" = false
    "THING_GROUP_HIERARCHY"  = false
    "THING_TYPE_ASSOCIATION" = false
    "JOB"                    = false
    "JOB_EXECUTION"          = false
    "POLICY"                 = false
    "CERTIFICATE"            = true
    "CA_CERTIFICATE"         = false
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AWSアカウントIDが設定されます。
#---------------------------------------------------------------
