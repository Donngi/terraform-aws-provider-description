#---------------------------------------------------------------
# AWS Neptune Event Subscription
#---------------------------------------------------------------
#
# Amazon NeptuneのイベントサブスクリプションをプロビジョニングするTerraformリソースです。
# Amazon SNSトピックを通じて、Neptuneクラスター・インスタンス・パラメータグループ等で
# 発生するイベントの通知を受信するサブスクリプションを作成します。
# ソースタイプ・ソースID・イベントカテゴリを組み合わせることで
# 通知対象をきめ細かく絞り込むことができます。
#
# AWS公式ドキュメント:
#   - Neptune イベント通知の概要: https://docs.aws.amazon.com/neptune/latest/userguide/events.html
#   - イベントサブスクリプションの作成: https://docs.aws.amazon.com/neptune/latest/userguide/events-subscribing.html
#   - CreateEventSubscription API: https://docs.aws.amazon.com/neptune/latest/apiref/API_CreateEventSubscription.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_event_subscription
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_neptune_event_subscription" "example" {
  #-------------------------------------------------------------
  # 通知先設定
  #-------------------------------------------------------------

  # sns_topic_arn (Required)
  # 設定内容: イベント通知の送信先となるSNSトピックのARNを指定します。
  # 設定可能な値: 有効なSNSトピックARN文字列
  # 参考: https://docs.aws.amazon.com/neptune/latest/apiref/API_CreateEventSubscription.html
  sns_topic_arn = "arn:aws:sns:ap-northeast-1:123456789012:neptune-events"

  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Optional)
  # 設定内容: イベントサブスクリプションの名前を指定します。
  # 設定可能な値: 255文字以内の文字列
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）
  name = "neptune-event-sub"

  # name_prefix (Optional)
  # 設定内容: イベントサブスクリプション名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraformが後ろにランダムなサフィックスを追加します。
  # 省略時: nameが指定されている場合は使用されません。
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  name_prefix = null

  #-------------------------------------------------------------
  # サブスクリプション有効化設定
  #-------------------------------------------------------------

  # enabled (Optional)
  # 設定内容: サブスクリプションを有効にするかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): サブスクリプションを有効化し、イベント通知を受信します。
  #   - false: サブスクリプションを作成しますが、通知は送信されません。
  # 省略時: true（有効）
  enabled = true

  #-------------------------------------------------------------
  # イベントソース設定
  #-------------------------------------------------------------

  # source_type (Optional)
  # 設定内容: イベントを生成するソースのタイプを指定します。
  # 設定可能な値:
  #   - "db-instance": DBインスタンスのイベントを対象とします。
  #   - "db-cluster": DBクラスターのイベントを対象とします。
  #   - "db-parameter-group": DBパラメータグループのイベントを対象とします。
  #   - "db-security-group": DBセキュリティグループのイベントを対象とします。
  #   - "db-snapshot": DBスナップショットのイベントを対象とします。
  #   - "db-cluster-snapshot": DBクラスタースナップショットのイベントを対象とします。
  # 省略時: 全てのソースタイプのイベントを対象とします。
  # 注意: source_idsを指定する場合は、source_typeも必ず指定する必要があります。
  source_type = "db-instance"

  # source_ids (Optional)
  # 設定内容: イベント通知の対象となるソースの識別子リストを指定します。
  # 設定可能な値: ソースIDの文字列セット。識別子は英字で始まり、英数字とハイフンのみ使用可能。
  #   末尾にハイフンや連続するハイフンは使用不可。
  # 省略時: 全てのソースが対象となります。
  # 注意: source_idsを指定する場合は、source_typeも必ず指定する必要があります。
  # 参考: https://docs.aws.amazon.com/neptune/latest/apiref/API_CreateEventSubscription.html
  source_ids = [
    "my-neptune-instance-1",
  ]

  # event_categories (Optional)
  # 設定内容: 通知対象とするイベントカテゴリのリストを指定します。
  # 設定可能な値: source_typeに対して有効なイベントカテゴリ名の文字列セット。
  #   利用可能なカテゴリは `aws neptune describe-event-categories` コマンドで確認できます。
  #   主なカテゴリ例（db-instance）:
  #   "maintenance", "availability", "creation", "backup", "restoration",
  #   "recovery", "deletion", "failover", "failure", "notification",
  #   "configuration change", "read replica"
  # 省略時: source_typeの全イベントカテゴリが対象となります。
  # 参考: https://docs.aws.amazon.com/neptune/latest/userguide/events.html
  event_categories = [
    "maintenance",
    "availability",
    "creation",
    "backup",
    "restoration",
    "recovery",
    "deletion",
    "failover",
    "failure",
    "notification",
    "configuration change",
    "read replica",
  ]

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "neptune-event-sub"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などのGo Duration形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "40m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などのGo Duration形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "40m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などのGo Duration形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "40m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Neptuneイベント通知サブスクリプションの名前
# - arn: Neptuneイベント通知サブスクリプションのARN
# - customer_aws_id: Neptuneイベント通知サブスクリプションに関連付けられたAWSカスタマーアカウントID
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられた全タグのマップ
#---------------------------------------------------------------
