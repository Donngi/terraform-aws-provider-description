#---------------------------------------------------------------
# Amazon DocumentDB Event Subscription
#---------------------------------------------------------------
#
# Amazon DocumentDB のイベント通知サブスクリプションを作成するリソースです。
# DocumentDB のイベント（インスタンス、クラスター、スナップショット、パラメータグループ関連）を
# Amazon SNS を通じて通知します。
#
# イベントサブスクリプションの主な特徴:
#   1. ソースタイプごとのイベント監視: インスタンス、クラスター、スナップショット等
#   2. イベントカテゴリの選択: 作成、削除、フェイルオーバー等の特定イベントのみ購読可能
#   3. SNS通知: メール、SMS、HTTPエンドポイント等への通知をサポート
#
# AWS公式ドキュメント:
#   - DocumentDB イベント通知: https://docs.aws.amazon.com/documentdb/latest/developerguide/event-subscriptions.html
#   - イベントカテゴリとメッセージ: https://docs.aws.amazon.com/documentdb/latest/developerguide/event-subscriptions.categories-messages.html
#   - イベントの管理: https://docs.aws.amazon.com/documentdb/latest/developerguide/managing-events.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_event_subscription
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_docdb_event_subscription" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional, Computed)
  # 設定内容: イベントサブスクリプションの名前を指定します。
  # 設定可能な値: 英数字とハイフンで構成される一意の名前
  # 省略時: Terraform が自動生成します
  # 注意: name_prefix と併用不可
  name = "example-docdb-event-subscription"

  # name_prefix (Optional, Computed)
  # 設定内容: イベントサブスクリプション名のプレフィックスを指定します。
  # 設定可能な値: 文字列
  # 省略時: 設定なし
  # 用途: Terraform が一意の名前を自動生成する際のプレフィックスとして使用
  # 注意: name と併用不可
  name_prefix = null

  # sns_topic_arn (Required)
  # 設定内容: イベント通知を送信する SNS トピックの ARN を指定します。
  # 設定可能な値: 有効な SNS トピックの ARN
  # 用途: DocumentDB イベントが発生した際の通知先を指定
  # 関連機能: Amazon SNS との統合
  #   イベント発生時に SNS トピックにメッセージを発行し、
  #   メール、SMS、Lambda 関数等への通知が可能。
  sns_topic_arn = "arn:aws:sns:ap-northeast-1:123456789012:docdb-events"

  # enabled (Optional)
  # 設定内容: サブスクリプションの有効/無効を指定します。
  # 設定可能な値:
  #   - true: サブスクリプションを有効化（デフォルト）
  #   - false: サブスクリプションを無効化（削除せずに一時停止）
  # 用途: メンテナンス時等に通知を一時的に停止する場合に使用
  enabled = true

  #-------------------------------------------------------------
  # イベントソース設定
  #-------------------------------------------------------------

  # source_type (Optional)
  # 設定内容: イベントを生成するソースのタイプを指定します。
  # 設定可能な値:
  #   - "db-instance": DocumentDB インスタンス関連のイベント
  #   - "db-cluster": DocumentDB クラスター関連のイベント
  #   - "db-parameter-group": パラメータグループ関連のイベント
  #   - "db-security-group": セキュリティグループ関連のイベント
  #   - "db-cluster-snapshot": クラスタースナップショット関連のイベント
  # 省略時: 全てのソースタイプからのイベントを購読
  # 注意: source_ids を指定する場合は source_type の指定が必須
  # 関連機能: イベントソースのフィルタリング
  #   特定のリソースタイプのみを監視することで、不要な通知を削減。
  source_type = "db-cluster"

  # source_ids (Optional)
  # 設定内容: イベントを購読する特定のソースの識別子リストを指定します。
  # 設定可能な値: source_type に応じた識別子のセット
  #   - db-instance: インスタンス識別子
  #   - db-cluster: クラスター識別子
  #   - db-parameter-group: パラメータグループ名
  #   - db-security-group: セキュリティグループ名
  #   - db-cluster-snapshot: スナップショット識別子
  # 省略時: 指定した source_type の全てのソースからイベントを購読
  # 注意: source_ids を指定する場合は source_type の指定が必須
  source_ids = ["example-docdb-cluster"]

  # event_categories (Optional)
  # 設定内容: 購読するイベントカテゴリのリストを指定します。
  # 設定可能な値（source_type により異なる）:
  #
  #   db-instance のカテゴリ:
  #     - "availability": インスタンスの再起動、シャットダウン
  #     - "configuration change": インスタンスクラスの変更、認証情報のリセット
  #     - "creation": インスタンスの作成
  #     - "deletion": インスタンスの削除
  #     - "failure": インスタンスの障害
  #     - "notification": インスタンスの停止、開始
  #     - "recovery": インスタンスのリカバリ
  #
  #   db-cluster のカテゴリ:
  #     - "creation": クラスターの作成
  #     - "deletion": クラスターの削除
  #     - "failover": フェイルオーバーの開始、完了
  #     - "maintenance": パッチ適用、アップグレード
  #     - "notification": クラスターの停止、開始、名前変更
  #
  #   db-parameter-group のカテゴリ:
  #     - "configuration change": パラメータの更新
  #
  #   db-cluster-snapshot (snapshot) のカテゴリ:
  #     - "backup": スナップショットの作成
  #
  # 省略時: 指定した source_type の全てのイベントカテゴリを購読
  # 参考: aws docdb describe-event-categories コマンドで利用可能なカテゴリを確認可能
  event_categories = ["creation", "deletion", "failover", "notification"]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWS リソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-docdb-event-subscription"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーの default_tags から継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraform が自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースの ID。イベントサブスクリプションの名前と同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraform が自動管理します
  id = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成、更新、削除操作のタイムアウトを設定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウトを指定します。
    # 設定可能な値: 時間文字列 (例: "40m", "1h")
    # 省略時: デフォルトのタイムアウト値を使用
    create = "40m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウトを指定します。
    # 設定可能な値: 時間文字列 (例: "40m", "1h")
    # 省略時: デフォルトのタイムアウト値を使用
    update = "40m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウトを指定します。
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
# - id: イベント通知サブスクリプションの名前
#
# - arn: イベント通知サブスクリプションの Amazon Resource Name (ARN)
#
# - customer_aws_id: このイベント通知サブスクリプションに関連付けられた
#   AWS カスタマーアカウント ID
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#   リソースに割り当てられた全てのタグのマップ
#---------------------------------------------------------------
