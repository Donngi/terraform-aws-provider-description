#---------------------------------------------------------------
# AWS IoT Event Configurations
#---------------------------------------------------------------
#
# AWS IoT Core のイベント通知設定を管理します。
# Thing、Thing Group、Thing Type、Job、Certificate などのリソースに対する
# イベント通知の有効/無効を制御します。
#
# イベントメッセージは MQTT で発行され、デバイスやアプリケーションが
# AWS IoT リソースの変更をリアルタイムで監視できるようになります。
#
# 注意: このリソースを削除してもイベント設定は無効化されません。
#       Terraform の状態から削除されるのみです。
#
# AWS公式ドキュメント:
#   - Event messages: https://docs.aws.amazon.com/iot/latest/developerguide/iot-events.html
#   - UpdateEventConfigurations API: https://docs.aws.amazon.com/iot/latest/apireference/API_UpdateEventConfigurations.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_event_configurations
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_event_configurations" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # event_configurations - (必須) イベント通知の設定マップ
  #
  # キーとして以下の文字列のみ使用可能:
  #   - CA_CERTIFICATE: CA証明書の登録イベント
  #   - CERTIFICATE: デバイス証明書の接続・切断・サブスクリプションイベント
  #   - JOB: ジョブの完了・キャンセルイベント
  #   - JOB_EXECUTION: ジョブ実行の成功・失敗・拒否・キャンセルイベント
  #   - POLICY: IoTポリシーのイベント
  #   - THING: Thingの作成・更新・削除イベント
  #   - THING_GROUP: Thing Groupの作成・更新・削除イベント
  #   - THING_GROUP_HIERARCHY: Thing Group階層構造の追加・削除イベント
  #   - THING_GROUP_MEMBERSHIP: Thing GroupへのThingの追加・削除イベント
  #   - THING_TYPE: Thing Typeの作成・更新・削除イベント
  #   - THING_TYPE_ASSOCIATION: ThingへのThing Type関連付けの追加・削除イベント
  #
  # 値は true (有効) または false (無効) のブール値を使用します。
  #
  # イベントメッセージは以下のトピックパターンで発行されます:
  #   - Thing: $aws/events/thing/{thingName}/created|updated|deleted
  #   - Job: $aws/events/job/{jobID}/completed|canceled
  #   - Certificate: $aws/events/presence/connected|disconnected/{clientId}
  #
  # Type: map(bool)
  event_configurations = {
    THING                  = true  # Thing の作成・更新・削除イベント
    THING_GROUP            = false # Thing Group の作成・更新・削除イベント
    THING_TYPE             = false # Thing Type の作成・更新・削除イベント
    THING_GROUP_MEMBERSHIP = false # Thing の Thing Group への追加・削除イベント
    THING_GROUP_HIERARCHY  = false # Thing Group 階層構造の変更イベント
    THING_TYPE_ASSOCIATION = false # Thing への Thing Type 関連付けイベント
    JOB                    = false # Job の完了・キャンセルイベント
    JOB_EXECUTION          = false # Job 実行の成功・失敗イベント
    POLICY                 = false # IoT ポリシーのイベント
    CERTIFICATE            = true  # 証明書の接続・切断イベント
    CA_CERTIFICATE         = false # CA 証明書の登録イベント
  }

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # region - (オプション) このリソースを管理するAWSリージョン
  #
  # 指定しない場合は、プロバイダー設定のリージョンが使用されます。
  # マルチリージョン構成で特定のリージョンを明示的に指定したい場合に使用します。
  #
  # AWS IoT のイベント設定はリージョン単位で管理されるため、
  # 複数のリージョンでイベント通知を有効化する場合は、
  # 各リージョンごとに本リソースを定義する必要があります。
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # Type: string
  # Default: プロバイダー設定のリージョン
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは以下の属性を公開します（computed属性）:
#
# - id - (string) AWS アカウント ID。このリソースの一意の識別子として使用されます。
#
# - region - (string) このリソースが管理されている AWS リージョン。
#                    optional パラメータとして指定可能ですが、
#                    指定しない場合はプロバイダー設定のリージョンが設定されます。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
#
# IoT Event Configurations は以下のコマンドでインポートできます:
#
#   terraform import aws_iot_event_configurations.example account-id
#
# 例:
#   terraform import aws_iot_event_configurations.example 123456789012
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 特定のイベントタイプのみを有効化
#---------------------------------------------------------------
#
# resource "aws_iot_event_configurations" "monitoring" {
#   event_configurations = {
#     # デバイス管理関連のイベントのみ有効化
#     THING                  = true
#     THING_GROUP            = true
#     THING_GROUP_MEMBERSHIP = true
#     CERTIFICATE            = true
#
#     # その他は無効化
#     THING_TYPE             = false
#     THING_GROUP_HIERARCHY  = false
#     THING_TYPE_ASSOCIATION = false
#     JOB                    = false
#     JOB_EXECUTION          = false
#     POLICY                 = false
#     CA_CERTIFICATE         = false
#   }
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: マルチリージョン構成
#---------------------------------------------------------------
#
# # US East リージョン
# resource "aws_iot_event_configurations" "us_east" {
#   region = "us-east-1"
#
#   event_configurations = {
#     THING       = true
#     CERTIFICATE = true
#     JOB         = true
#     # ... その他のイベントタイプ
#   }
# }
#
# # EU West リージョン
# resource "aws_iot_event_configurations" "eu_west" {
#   region = "eu-west-1"
#
#   event_configurations = {
#     THING       = true
#     CERTIFICATE = true
#     JOB         = true
#     # ... その他のイベントタイプ
#   }
# }
#
#---------------------------------------------------------------
