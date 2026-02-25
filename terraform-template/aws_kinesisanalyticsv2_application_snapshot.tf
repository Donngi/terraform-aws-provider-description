#---------------------------------------------------------------
# Amazon Kinesis Data Analytics v2 Application Snapshot
#---------------------------------------------------------------
#
# Amazon Kinesis Data Analytics v2アプリケーションのスナップショットを管理するリソースです。
# スナップショットはFlink-basedアプリケーションの状態をポイントインタイムで保存し、
# アプリケーションのリストアや移行に使用できます。
#
# AWS公式ドキュメント:
#   - スナップショット概要: https://docs.aws.amazon.com/managed-flink/latest/java/how-fault-snapshot.html
#   - CreateApplicationSnapshot API: https://docs.aws.amazon.com/managed-flink/latest/apiv2/API_CreateApplicationSnapshot.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesisanalyticsv2_application_snapshot
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kinesisanalyticsv2_application_snapshot" "example" {
  #-------------------------------------------------------------
  # アプリケーション設定
  #-------------------------------------------------------------

  # application_name (Required)
  # 設定内容: スナップショットを作成する対象のアプリケーション名を指定します。
  # 設定可能な値: 既存のKinesis Data Analytics v2アプリケーション名
  application_name = "example-kinesis-analytics-app"

  # snapshot_name (Required)
  # 設定内容: スナップショットの名前を指定します。
  # 設定可能な値: 文字列（アプリケーション内で一意である必要があります）
  snapshot_name = "example-snapshot"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
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
    # 設定内容: スナップショット作成操作のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウトを使用
    create = "10m"

    # delete (Optional)
    # 設定内容: スナップショット削除操作のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウトを使用
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# id                          - スナップショットの識別子（application_name/snapshot_nameの形式）
# application_version_id      - スナップショット作成時のアプリケーションバージョンID
# snapshot_creation_timestamp - スナップショットが作成された日時（ISO 8601形式）
#
#---------------------------------------------------------------
