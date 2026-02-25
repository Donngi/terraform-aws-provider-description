#---------------------------------------------------------------
# Amazon MSK Replicator
#---------------------------------------------------------------
#
# Amazon MSK Replicator は、2つの Amazon MSK クラスター間で
# Kafka トピックとコンシューマーグループをレプリケーションするリソースです。
# 異なるリージョンまたは同一リージョン内のクラスター間でのデータ複製を
# 可能にし、ディザスタリカバリや地理的分散処理に活用できます。
#
# AWS公式ドキュメント:
#   - Amazon MSK Replicator: https://docs.aws.amazon.com/msk/latest/developerguide/msk-replicator.html
#   - MSK Replicator の開始方法: https://docs.aws.amazon.com/msk/latest/developerguide/msk-replicator-getting-started.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_replicator
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_msk_replicator" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # replicator_name (Required)
  # 設定内容: MSK Replicator の名前を指定します。
  # 設定可能な値: 英字、数字、ハイフン、アンダースコアを含む文字列
  replicator_name = "example-msk-replicator"

  # service_execution_role_arn (Required)
  # 設定内容: MSK Replicator がレプリケーション処理を行う際に使用する
  #          IAM ロールの ARN を指定します。
  # 設定可能な値: 有効な IAM ロールの ARN
  # 注意: このロールには、ソース・ターゲット MSK クラスターへのアクセス権限が必要です。
  #       具体的には kafka-cluster:Connect、kafka-cluster:DescribeCluster 等の権限が必要です。
  service_execution_role_arn = "arn:aws:iam::123456789012:role/msk-replicator-role"

  # description (Optional)
  # 設定内容: MSK Replicator の説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Example MSK Replicator for cross-cluster topic replication"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理する AWS リージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: us-east-1, ap-northeast-1）
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
  tags = {
    Name        = "example-msk-replicator"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # Kafka クラスター設定
  #-------------------------------------------------------------

  # kafka_cluster (Required, 2ブロック必須)
  # 設定内容: レプリケーション対象の Kafka クラスター（ソースとターゲット）を
  #          指定するブロックです。ちょうど2つのブロックが必要です。
  # 注意: replication_info_list で指定する source_kafka_cluster_arn と
  #       target_kafka_cluster_arn はここで定義したクラスターを参照します。
  kafka_cluster {
    # amazon_msk_cluster (Required)
    # 設定内容: Amazon MSK クラスターを指定するブロックです。
    amazon_msk_cluster {
      # msk_cluster_arn (Required)
      # 設定内容: ソース MSK クラスターの ARN を指定します。
      # 設定可能な値: 有効な MSK クラスターの ARN
      msk_cluster_arn = "arn:aws:kafka:us-east-1:123456789012:cluster/source-cluster/abcdef01-1234-5678-abcd-ef0123456789-1"
    }

    # vpc_config (Required)
    # 設定内容: MSK クラスターが属する VPC ネットワーク設定を指定するブロックです。
    vpc_config {
      # subnet_ids (Required)
      # 設定内容: MSK クラスターが存在するサブネット ID のセットを指定します。
      # 設定可能な値: 有効なサブネット ID の集合
      subnet_ids = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]

      # security_groups_ids (Optional)
      # 設定内容: MSK クラスターに適用するセキュリティグループ ID のセットを指定します。
      # 設定可能な値: 有効なセキュリティグループ ID の集合
      # 省略時: セキュリティグループなし
      security_groups_ids = ["sg-0123456789abcdef0"]
    }
  }

  kafka_cluster {
    amazon_msk_cluster {
      # msk_cluster_arn (Required)
      # 設定内容: ターゲット MSK クラスターの ARN を指定します。
      # 設定可能な値: 有効な MSK クラスターの ARN
      msk_cluster_arn = "arn:aws:kafka:us-west-2:123456789012:cluster/target-cluster/abcdef01-1234-5678-abcd-ef0123456789-2"
    }

    vpc_config {
      # subnet_ids (Required)
      # 設定内容: ターゲット MSK クラスターが存在するサブネット ID のセットを指定します。
      # 設定可能な値: 有効なサブネット ID の集合
      subnet_ids = ["subnet-0abcdef1234567890", "subnet-0abcdef1234567891"]

      # security_groups_ids (Optional)
      # 設定内容: ターゲット MSK クラスターに適用するセキュリティグループ ID のセットを指定します。
      # 設定可能な値: 有効なセキュリティグループ ID の集合
      # 省略時: セキュリティグループなし
      security_groups_ids = ["sg-0abcdef1234567890"]
    }
  }

  #-------------------------------------------------------------
  # レプリケーション情報設定
  #-------------------------------------------------------------

  # replication_info_list (Required, 1ブロック必須)
  # 設定内容: レプリケーションの詳細設定を行うブロックです。
  #          ソースとターゲットのクラスター、トピックおよびコンシューマーグループの
  #          レプリケーションポリシーを定義します。
  replication_info_list {
    # source_kafka_cluster_arn (Required)
    # 設定内容: レプリケーション元となるソース MSK クラスターの ARN を指定します。
    # 設定可能な値: kafka_cluster ブロックで定義した MSK クラスターの ARN
    source_kafka_cluster_arn = "arn:aws:kafka:us-east-1:123456789012:cluster/source-cluster/abcdef01-1234-5678-abcd-ef0123456789-1"

    # target_kafka_cluster_arn (Required)
    # 設定内容: レプリケーション先となるターゲット MSK クラスターの ARN を指定します。
    # 設定可能な値: kafka_cluster ブロックで定義した MSK クラスターの ARN
    target_kafka_cluster_arn = "arn:aws:kafka:us-west-2:123456789012:cluster/target-cluster/abcdef01-1234-5678-abcd-ef0123456789-2"

    # target_compression_type (Required)
    # 設定内容: ターゲットクラスターに書き込む際のメッセージ圧縮タイプを指定します。
    # 設定可能な値:
    #   - "NONE": 圧縮なし（ソースのまま転送）
    #   - "GZIP": GZIP 圧縮（高圧縮率、CPU使用量多）
    #   - "SNAPPY": Snappy 圧縮（バランス型）
    #   - "LZ4": LZ4 圧縮（高速、低圧縮率）
    #   - "ZSTD": Zstandard 圧縮（高圧縮率、高速）
    target_compression_type = "NONE"

    #-----------------------------------------------------------
    # コンシューマーグループレプリケーション設定
    #-----------------------------------------------------------

    # consumer_group_replication (Required, 1ブロック以上)
    # 設定内容: コンシューマーグループのレプリケーションポリシーを定義するブロックです。
    consumer_group_replication {
      # consumer_groups_to_replicate (Required)
      # 設定内容: レプリケーション対象のコンシューマーグループ名パターンのセットを指定します。
      # 設定可能な値: コンシューマーグループ名または正規表現パターンの集合
      #   - ".*": 全コンシューマーグループを対象
      #   - "my-consumer-group": 特定グループ名を指定
      consumer_groups_to_replicate = [".*"]

      # consumer_groups_to_exclude (Optional)
      # 設定内容: レプリケーション除外対象のコンシューマーグループ名パターンのセットを指定します。
      # 設定可能な値: コンシューマーグループ名または正規表現パターンの集合
      # 省略時: 除外グループなし
      consumer_groups_to_exclude = []

      # detect_and_copy_new_consumer_groups (Optional)
      # 設定内容: ソースクラスターで新たに作成されたコンシューマーグループを
      #          自動的に検出してレプリケーション対象に追加するかどうかを指定します。
      # 設定可能な値: true, false
      #   - true: 新規コンシューマーグループを自動検出してコピー
      #   - false: 既存のパターン設定のみに従う
      # 省略時: AWSのデフォルト値を使用
      detect_and_copy_new_consumer_groups = true

      # synchronise_consumer_group_offsets (Optional)
      # 設定内容: コンシューマーグループのオフセット情報をターゲットクラスターに
      #          同期するかどうかを指定します。
      # 設定可能な値: true, false
      #   - true: オフセットを同期（フェイルオーバー時に消費再開位置を保持）
      #   - false: オフセットを同期しない
      # 省略時: AWSのデフォルト値を使用
      synchronise_consumer_group_offsets = true
    }

    #-----------------------------------------------------------
    # トピックレプリケーション設定
    #-----------------------------------------------------------

    # topic_replication (Required, 1ブロック以上)
    # 設定内容: Kafka トピックのレプリケーションポリシーを定義するブロックです。
    topic_replication {
      # topics_to_replicate (Required)
      # 設定内容: レプリケーション対象のトピック名パターンのセットを指定します。
      # 設定可能な値: トピック名または正規表現パターンの集合
      #   - ".*": 全トピックを対象
      #   - "my-topic": 特定トピック名を指定
      topics_to_replicate = [".*"]

      # topics_to_exclude (Optional)
      # 設定内容: レプリケーション除外対象のトピック名パターンのセットを指定します。
      # 設定可能な値: トピック名または正規表現パターンの集合
      # 省略時: 除外トピックなし
      topics_to_exclude = []

      # copy_access_control_lists_for_topics (Optional)
      # 設定内容: トピックのアクセスコントロールリスト（ACL）をターゲットクラスターに
      #          コピーするかどうかを指定します。
      # 設定可能な値: true, false
      #   - true: ACL をターゲットクラスターにコピー
      #   - false: ACL をコピーしない
      # 省略時: AWSのデフォルト値を使用
      copy_access_control_lists_for_topics = false

      # copy_topic_configurations (Optional)
      # 設定内容: トピックの設定（保持期間、パーティション数等）を
      #          ターゲットクラスターにコピーするかどうかを指定します。
      # 設定可能な値: true, false
      #   - true: トピック設定をターゲットクラスターにコピー
      #   - false: トピック設定をコピーしない
      # 省略時: AWSのデフォルト値を使用
      copy_topic_configurations = true

      # detect_and_copy_new_topics (Optional)
      # 設定内容: ソースクラスターで新たに作成されたトピックを
      #          自動的に検出してレプリケーション対象に追加するかどうかを指定します。
      # 設定可能な値: true, false
      #   - true: 新規トピックを自動検出してコピー
      #   - false: 既存のパターン設定のみに従う
      # 省略時: AWSのデフォルト値を使用
      detect_and_copy_new_topics = true

      # starting_position (Optional, 最大1ブロック)
      # 設定内容: トピックレプリケーションを開始する位置を指定するブロックです。
      # 省略時: AWSのデフォルト開始位置を使用
      starting_position {
        # type (Optional)
        # 設定内容: レプリケーション開始位置のタイプを指定します。
        # 設定可能な値:
        #   - "LATEST": 最新メッセージからレプリケーションを開始
        #   - "EARLIEST": 最古のメッセージからレプリケーションを開始
        # 省略時: AWSのデフォルト値を使用
        type = "LATEST"
      }

      # topic_name_configuration (Optional, 最大1ブロック)
      # 設定内容: ターゲットクラスターでのトピック名の命名規則を指定するブロックです。
      # 省略時: AWSのデフォルト命名規則を使用
      topic_name_configuration {
        # type (Optional)
        # 設定内容: ターゲットクラスターでのトピック名形式を指定します。
        # 設定可能な値:
        #   - "PREFIXED_WITH_SOURCE_CLUSTER_ALIAS": ソースクラスターエイリアスをプレフィックスとして付与
        #   - "IDENTICAL": ソースと同じトピック名を使用
        # 省略時: AWSのデフォルト値を使用
        type = "PREFIXED_WITH_SOURCE_CLUSTER_ALIAS"
      }
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: MSK Replicator の作成操作のタイムアウト時間を指定します。
    # 設定可能な値: Go の時間パース形式（例: "30m", "1h"）
    # 省略時: Terraform のデフォルトタイムアウトを使用
    create = "30m"

    # update (Optional)
    # 設定内容: MSK Replicator の更新操作のタイムアウト時間を指定します。
    # 設定可能な値: Go の時間パース形式（例: "30m", "1h"）
    # 省略時: Terraform のデフォルトタイムアウトを使用
    update = "30m"

    # delete (Optional)
    # 設定内容: MSK Replicator の削除操作のタイムアウト時間を指定します。
    # 設定可能な値: Go の時間パース形式（例: "30m", "1h"）
    # 省略時: Terraform のデフォルトタイムアウトを使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: MSK Replicator の ARN
#
# - current_version: MSK Replicator の現在のバージョン文字列（更新時に使用）
#
# - id: MSK Replicator の ARN（arn と同値）
#
# - replication_info_list[*].source_kafka_cluster_alias: ソースクラスターのエイリアス名
#
# - replication_info_list[*].target_kafka_cluster_alias: ターゲットクラスターのエイリアス名
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
