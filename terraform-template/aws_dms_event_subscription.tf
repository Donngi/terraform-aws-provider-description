#---------------------------------------------------------------
# AWS DMS Event Subscription
#---------------------------------------------------------------
#
# AWS Database Migration Service (DMS) のイベントサブスクリプションを
# プロビジョニングするリソースです。
# イベントサブスクリプションを使用すると、レプリケーションインスタンスや
# レプリケーションタスクで発生する特定のイベントに対して、
# Amazon SNS経由で通知を受け取ることができます。
#
# AWS公式ドキュメント:
#   - DMS概要: https://docs.aws.amazon.com/dms/latest/userguide/Welcome.html
#   - DMSイベントとEventBridge: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_EventBridge.html
#   - CreateEventSubscription API: https://docs.aws.amazon.com/dms/latest/APIReference/API_CreateEventSubscription.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_event_subscription
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dms_event_subscription" "example" {
  #-------------------------------------------------------------
  # 基本設定 (Required)
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: イベントサブスクリプションの名前を指定します。
  # 設定可能な値: 文字列（一意の識別子）
  # 注意: この名前はサブスクリプションを識別するために使用されます
  name = "my-dms-event-subscription"

  # sns_topic_arn (Required)
  # 設定内容: イベント通知を送信するAmazon SNSトピックのARNを指定します。
  # 設定可能な値: 有効なSNSトピックARN
  # 注意: SNSトピックへの発行権限がDMSに必要です
  # 関連機能: Amazon SNS
  #   - https://docs.aws.amazon.com/sns/latest/dg/welcome.html
  sns_topic_arn = "arn:aws:sns:ap-northeast-1:123456789012:dms-events"

  # source_type (Required)
  # 設定内容: イベントのソースタイプを指定します。
  # 設定可能な値:
  #   - "replication-instance": レプリケーションインスタンスのイベント
  #   - "replication-task": レプリケーションタスクのイベント
  # 注意: source_typeによって利用可能なevent_categoriesが異なります
  source_type = "replication-task"

  # event_categories (Required)
  # 設定内容: 購読するイベントカテゴリのリストを指定します。
  # 設定可能な値（source_type = "replication-instance" の場合）:
  #   - "creation": インスタンスの作成イベント
  #   - "deletion": インスタンスの削除イベント
  #   - "configuration change": 設定変更イベント
  #   - "maintenance": メンテナンスイベント
  #   - "failover": フェイルオーバーイベント
  #   - "failure": 障害イベント
  #   - "low storage": ストレージ不足イベント
  # 設定可能な値（source_type = "replication-task" の場合）:
  #   - "creation": タスクの作成イベント
  #   - "deletion": タスクの削除イベント
  #   - "configuration change": 設定変更イベント
  #   - "state change": 状態変更イベント
  #   - "failure": 障害イベント
  # 参考: DescribeEventCategories APIでサポートされるカテゴリを確認可能
  #   - https://docs.aws.amazon.com/dms/latest/APIReference/API_DescribeEventCategories.html
  event_categories = [
    "creation",
    "failure",
    "state change",
  ]

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # enabled (Optional)
  # 設定内容: イベントサブスクリプションを有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true: サブスクリプションを有効化（通知を受け取る）
  #   - false: サブスクリプションを無効化（通知を停止）
  # 省略時: true
  enabled = true

  # source_ids (Optional)
  # 設定内容: イベントを購読するソースの識別子リストを指定します。
  # 設定可能な値:
  #   - source_type = "replication-instance" の場合: レプリケーションインスタンス名のリスト
  #   - source_type = "replication-task" の場合: レプリケーションタスクIDのリスト
  # 省略時: 指定したsource_typeのすべてのソースからイベントを受信
  # 注意: 特定のリソースに限定したい場合のみ指定
  source_ids = [
    "my-replication-task-1",
    "my-replication-task-2",
  ]

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "my-dms-event-subscription"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用
    create = "10m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用
    update = "10m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: DMSイベントサブスクリプションのAmazon Resource Name (ARN)
#
# - id: イベントサブスクリプションの名前
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
