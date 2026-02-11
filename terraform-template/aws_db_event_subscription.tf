#---------------------------------------------------------------
# Amazon RDS DB Event Subscription
#---------------------------------------------------------------
#
# Amazon RDS DBイベントサブスクリプションを作成・管理するリソースです。
# イベントサブスクリプションを使用すると、RDSリソース（DBインスタンス、
# DBクラスター、セキュリティグループ等）で発生するイベントの通知を
# Amazon SNSトピックに送信できます。
#
# AWS公式ドキュメント:
#   - RDS イベント通知の概要: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Events.html
#   - イベントカテゴリ一覧: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Events.Messages.html
#   - RDS API リファレンス: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_event_subscription
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_db_event_subscription" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # sns_topic (Required)
  # 設定内容: イベント通知を送信するSNSトピックのARNを指定します。
  # 設定可能な値: 有効なSNSトピックのARN
  # 用途: RDSイベントの通知先として必須
  # 関連機能: Amazon SNS
  #   イベントが発生すると、指定したSNSトピックに通知が送信されます。
  #   Eメール、SMS、Lambda関数などのサブスクリプションを設定できます。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Events.html
  sns_topic = "arn:aws:sns:ap-northeast-1:123456789012:rds-events"

  # name (Optional, Computed)
  # 設定内容: DBイベントサブスクリプションの名前を指定します。
  # 設定可能な値: 1〜255文字の英数字、ハイフン、アンダースコア
  # 省略時: Terraformが自動生成します
  # 注意: name_prefix との同時指定は不可
  # 関連機能: イベントサブスクリプションの識別子
  #   イベントサブスクリプションを識別するための一意の名前。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Events.html
  name = "rds-event-subscription"

  # name_prefix (Optional, Computed)
  # 設定内容: サブスクリプション名のプレフィックスを指定します。
  # 設定可能な値: 有効な文字列 (Terraformがプレフィックスに基づき名前を自動生成)
  # 省略時: なし
  # 注意: name との同時指定は不可
  # 用途: create_before_destroy ライフサイクルルールと組み合わせて使用する場合に便利
  name_prefix = null

  #-------------------------------------------------------------
  # イベントソース設定
  #-------------------------------------------------------------

  # source_type (Optional)
  # 設定内容: イベントを生成するソースタイプを指定します。
  # 設定可能な値:
  #   - "db-instance": DBインスタンスのイベント
  #   - "db-security-group": DBセキュリティグループのイベント
  #   - "db-parameter-group": DBパラメータグループのイベント
  #   - "db-snapshot": DBスナップショットのイベント
  #   - "db-cluster": DBクラスターのイベント (Aurora)
  #   - "db-cluster-snapshot": DBクラスタースナップショットのイベント (Aurora)
  #   - "db-proxy": RDS Proxyのイベント
  # 省略時: 全てのソースタイプからのイベントを購読
  # 注意: source_ids を指定する場合は source_type の指定が必須
  # 関連機能: RDS イベントソース
  #   特定のRDSリソースタイプに絞ってイベントを受信できます。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Events.html
  source_type = "db-instance"

  # source_ids (Optional)
  # 設定内容: イベントを生成する特定のソース識別子のリストを指定します。
  # 設定可能な値: RDSリソースの識別子（例: DBインスタンス識別子、DBクラスター識別子）
  # 省略時: source_type で指定された全てのソースからイベントを受信
  # 注意: source_ids を指定する場合は source_type の指定が必須
  # 関連機能: イベントソースフィルタリング
  #   特定のRDSリソースのみからイベントを受信したい場合に使用。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Events.html
  source_ids = ["mydb-instance-1", "mydb-instance-2"]

  # event_categories (Optional)
  # 設定内容: 購読するイベントカテゴリのリストを指定します。
  # 設定可能な値 (source_type により異なる):
  #   db-instance の場合:
  #     - "availability": 可用性に関するイベント
  #     - "backup": バックアップ操作イベント
  #     - "configuration change": 設定変更イベント
  #     - "creation": 作成イベント
  #     - "deletion": 削除イベント
  #     - "failover": フェイルオーバーイベント
  #     - "failure": 障害イベント
  #     - "low storage": ストレージ不足イベント
  #     - "maintenance": メンテナンスイベント
  #     - "notification": 通知イベント
  #     - "read replica": リードレプリカ関連イベント
  #     - "recovery": リカバリイベント
  #     - "restoration": 復元イベント
  #     - "security": セキュリティイベント
  #     - "security patching": セキュリティパッチ適用イベント
  #   db-cluster の場合:
  #     - "failover", "failure", "maintenance", "notification" など
  # 省略時: 全てのイベントカテゴリを購読
  # 確認コマンド: aws rds describe-event-categories
  # 関連機能: RDS イベントカテゴリ
  #   イベントカテゴリを指定して、必要なイベントのみを受信できます。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Events.Messages.html
  event_categories = [
    "availability",
    "deletion",
    "failover",
    "failure",
    "low storage",
    "maintenance",
    "notification",
    "read replica",
    "recovery",
    "restoration",
  ]

  #-------------------------------------------------------------
  # サブスクリプション設定
  #-------------------------------------------------------------

  # enabled (Optional)
  # 設定内容: イベントサブスクリプションの有効/無効を指定します。
  # 設定可能な値:
  #   - true: サブスクリプションが有効 (イベント通知を送信)
  #   - false: サブスクリプションが無効 (イベント通知を停止)
  # 省略時: true (有効)
  # 用途: 一時的にイベント通知を停止したい場合に false に設定
  # 関連機能: イベントサブスクリプションの有効化/無効化
  #   サブスクリプションを削除せずに通知を一時停止できます。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Events.html
  enabled = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
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
  tags = {
    Name        = "rds-event-subscription"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: RDSイベント通知サブスクリプションの名前
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・更新・削除操作のタイムアウト値を指定します。
  # 用途: 操作に時間がかかる場合や、デフォルトのタイムアウトでは不十分な場合に調整
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト値を指定します。
    # 設定可能な値: 時間文字列 (例: "40m", "1h")
    # 省略時: デフォルトのタイムアウト値を使用
    create = "40m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト値を指定します。
    # 設定可能な値: 時間文字列 (例: "40m", "1h")
    # 省略時: デフォルトのタイムアウト値を使用
    update = "40m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト値を指定します。
    # 設定可能な値: 時間文字列 (例: "40m", "1h")
    # 省略時: デフォルトのタイムアウト値を使用
    delete = "40m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: RDSイベント通知サブスクリプションの名前
#
# - arn: RDSイベント通知サブスクリプションのAmazon Resource Name (ARN)
#
# - customer_aws_id: RDSイベント通知サブスクリプションに関連付けられた
#   AWSカスタマーアカウントID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
