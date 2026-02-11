#---------------------------------------------------------------
# aws_neptune_event_subscription
#---------------------------------------------------------------
#
# Amazon Neptune イベントサブスクリプションを作成するリソース。
# Neptune のイベント（インスタンス、クラスター、スナップショット等の変更）
# を Amazon SNS トピック経由で通知を受け取ることができる。
#
# AWS公式ドキュメント:
#   - Using Neptune Event Notification: https://docs.aws.amazon.com/neptune/latest/userguide/events.html
#   - Subscribing to Neptune event notification: https://docs.aws.amazon.com/neptune/latest/userguide/events-subscribing.html
#   - CreateEventSubscription API: https://docs.aws.amazon.com/neptune/latest/apiref/API_CreateEventSubscription.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_event_subscription
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_neptune_event_subscription" "example" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # sns_topic_arn (Required, string):
  #   イベント通知を送信する SNS トピックの ARN。
  #   Neptune イベントが発生した際に、このトピックに通知が送信される。
  #   事前に SNS トピックを作成し、適切なアクセス許可を設定しておく必要がある。
  sns_topic_arn = "arn:aws:sns:ap-northeast-1:123456789012:neptune-events"

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # name (Optional, string):
  #   Neptune イベントサブスクリプションの名前。
  #   指定しない場合、Terraform により自動生成される。
  #   name_prefix と同時に指定することはできない。
  name = "neptune-event-subscription"

  # name_prefix (Optional, string):
  #   Neptune イベントサブスクリプション名のプレフィックス。
  #   指定すると、このプレフィックスに続くユニークな名前が自動生成される。
  #   name と同時に指定することはできない。
  # name_prefix = "neptune-"

  # enabled (Optional, bool):
  #   サブスクリプションを有効にするかどうか。
  #   true: サブスクリプションが有効で、イベント通知が送信される。
  #   false: サブスクリプションが無効で、イベント通知は送信されない。
  #   デフォルト: true
  enabled = true

  # source_type (Optional, string):
  #   イベントを生成するソースのタイプ。
  #   指定可能な値:
  #   - "db-instance": DB インスタンスのイベント
  #   - "db-security-group": DB セキュリティグループのイベント
  #   - "db-parameter-group": DB パラメータグループのイベント
  #   - "db-snapshot": DB スナップショットのイベント
  #   - "db-cluster": DB クラスターのイベント
  #   - "db-cluster-snapshot": DB クラスタースナップショットのイベント
  #   指定しない場合、すべてのソースタイプのイベントが対象となる。
  source_type = "db-instance"

  # source_ids (Optional, set of string):
  #   イベント通知を受け取るソースの識別子リスト。
  #   source_type を指定した場合のみ使用可能。
  #   指定しない場合、該当する source_type の全ソースからイベントを受信する。
  #   例: DB インスタンスの ID、クラスターの ID など。
  source_ids = ["neptune-instance-1", "neptune-instance-2"]

  # event_categories (Optional, set of string):
  #   通知を受け取るイベントカテゴリのリスト。
  #   source_type ごとに利用可能なカテゴリが異なる。
  #   利用可能なカテゴリは `aws neptune describe-event-categories` コマンドで確認可能。
  #
  #   主なイベントカテゴリ:
  #   - "availability": 可用性に関するイベント
  #   - "backup": バックアップに関するイベント
  #   - "configuration change": 設定変更に関するイベント
  #   - "creation": 作成に関するイベント
  #   - "deletion": 削除に関するイベント
  #   - "failover": フェイルオーバーに関するイベント
  #   - "failure": 障害に関するイベント
  #   - "maintenance": メンテナンスに関するイベント
  #   - "notification": 通知に関するイベント
  #   - "read replica": リードレプリカに関するイベント
  #   - "recovery": 復旧に関するイベント
  #   - "restoration": リストアに関するイベント
  event_categories = [
    "availability",
    "backup",
    "configuration change",
    "creation",
    "deletion",
    "failover",
    "failure",
    "maintenance",
    "notification",
    "read replica",
    "recovery",
    "restoration",
  ]

  # tags (Optional, map of string):
  #   リソースに付与するタグ。
  #   プロバイダーレベルで default_tags が設定されている場合、
  #   同じキーのタグはこの設定で上書きされる。
  tags = {
    Name        = "neptune-event-subscription"
    Environment = "production"
  }

  # tags_all (Optional/Computed, map of string):
  #   プロバイダーの default_tags を含む全てのタグ。
  #   この属性は Computed であり、直接設定する必要はない。
  #   tags と default_tags がマージされた結果が格納される。

  # region (Optional, string):
  #   リソースを管理するリージョン。
  #   指定しない場合、プロバイダー設定のリージョンが使用される。
  # region = "ap-northeast-1"

  # id (Optional/Computed, string):
  #   リソース ID。通常は Terraform が自動管理するため指定不要。
  #   インポート時などに使用される。

  #---------------------------------------------------------------
  # ネストブロック (Nested Blocks)
  #---------------------------------------------------------------

  # timeouts (Optional, block):
  #   各操作のタイムアウト設定。
  #   指定しない場合、デフォルトのタイムアウト値が適用される。
  timeouts {
    # create (Optional, string):
    #   リソース作成時のタイムアウト。
    #   形式: "60m" (60分)、"1h" (1時間) など。
    create = "40m"

    # update (Optional, string):
    #   リソース更新時のタイムアウト。
    #   形式: "60m" (60分)、"1h" (1時間) など。
    update = "40m"

    # delete (Optional, string):
    #   リソース削除時のタイムアウト。
    #   形式: "60m" (60分)、"1h" (1時間) など。
    delete = "40m"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能（Computed属性）:
#
# - id: Neptune イベント通知サブスクリプションの名前。
#
# - arn: Neptune イベント通知サブスクリプションの Amazon Resource Name (ARN)。
#   例: "arn:aws:rds:ap-northeast-1:123456789012:es:neptune-event-subscription"
#
# - customer_aws_id: Neptune イベント通知サブスクリプションに関連付けられた
#   AWS カスタマーアカウント ID。
#
# - tags_all: プロバイダーの default_tags を含む全てのタグのマップ。
#---------------------------------------------------------------
