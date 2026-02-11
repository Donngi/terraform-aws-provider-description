#---------------------------------------------------------------
# Amazon MSK Replicator
#---------------------------------------------------------------
#
# Amazon MSK Replicatorは、Amazon Managed Streaming for Apache Kafka (MSK)
# クラスター間でデータを自動的にレプリケートするフルマネージドサービスです。
# 同一リージョン内または異なるAWSリージョン間でのクロスクラスターレプリケーションを
# 実現し、マルチリージョンアーキテクチャ、ディザスタリカバリ、データ集約などの
# ユースケースをサポートします。
#
# 主な特徴:
#   - フルマネージドで自動スケーリング
#   - データの非同期レプリケーション（メモリ内バッファリング、データ保存なし）
#   - トピック設定、ACL、コンシューマーグループオフセットのメタデータレプリケーション
#   - Prefixed（デフォルト）またはIdenticalトピック名設定モード
#   - 通信およびデータの転送中暗号化
#
# AWS公式ドキュメント:
#   - MSK Replicatorの仕組み: https://docs.aws.amazon.com/msk/latest/developerguide/msk-replicator-how-it-works.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_replicator
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_msk_replicator" "example" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # (Required) Replicatorの名前
  # クラスター間レプリケーションを識別するための一意の名前を指定します。
  replicator_name = "example-replicator"

  # (Required) Replicatorが使用するIAMロールのARN
  # Replicatorがソースおよびターゲットクラスターにアクセスするために使用するロールです。
  # このロールには、MSKクラスターへの読み取り/書き込み権限、
  # VPC内のENI作成権限などが必要です。
  service_execution_role_arn = "arn:aws:iam::123456789012:role/msk-replicator-role"

  # (Optional) Replicatorの説明
  # このReplicatorの目的や用途を記述します。
  description = "Cross-region replication from source to target cluster"

  # (Optional) リソースを管理するAWSリージョン
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  # Replicatorはターゲットクラスターのリージョンに作成することが推奨されます。
  # region = "ap-northeast-1"

  # (Optional) リソースに割り当てるタグのマップ
  # プロバイダーレベルの default_tags が設定されている場合、
  # 同じキーを持つタグはここで定義されたものが優先されます。
  tags = {
    Name        = "example-replicator"
    Environment = "production"
  }

  #---------------------------------------------------------------
  # kafka_cluster ブロック (Required, 2つ必須)
  #---------------------------------------------------------------
  # Replicatorのソースおよびターゲットとなるkafkaクラスターを定義します。
  # 必ず2つのkafka_clusterブロックを指定する必要があります（ソース1つ、ターゲット1つ）。
  # どちらがソースでどちらがターゲットかは、replication_info_list内で指定します。

  # ソースクラスター
  kafka_cluster {
    # (Required) Amazon MSKクラスターの設定
    amazon_msk_cluster {
      # (Required) MSKクラスターのARN
      # レプリケーションのソースまたはターゲットとなるMSKクラスターを指定します。
      msk_cluster_arn = "arn:aws:kafka:us-east-1:123456789012:cluster/source-cluster/12345678-1234-1234-1234-123456789012-1"
    }

    # (Required) VPC設定
    # ReplicatorがKafkaクラスターと通信するためのネットワーク設定です。
    vpc_config {
      # (Required) VPC内のサブネットIDのリスト
      # AWSはこれらのサブネット内にElastic Network Interface (ENI)を作成し、
      # KafkaクラスターとReplicator間の通信を可能にします。
      # 高可用性のため、複数のアベイラビリティゾーンにまたがるサブネットを指定することを推奨します。
      subnet_ids = [
        "subnet-xxxxxxxxxxxxxxxxx",
        "subnet-yyyyyyyyyyyyyyyyy",
        "subnet-zzzzzzzzzzzzzzzzz",
      ]

      # (Optional) ENIに関連付けるセキュリティグループIDのリスト
      # 指定しない場合、VPCのデフォルトセキュリティグループが使用されます。
      # MSKクラスターへのアクセスを許可するセキュリティグループを指定してください。
      security_groups_ids = [
        "sg-xxxxxxxxxxxxxxxxx",
      ]
    }
  }

  # ターゲットクラスター
  kafka_cluster {
    amazon_msk_cluster {
      msk_cluster_arn = "arn:aws:kafka:ap-northeast-1:123456789012:cluster/target-cluster/87654321-4321-4321-4321-210987654321-1"
    }

    vpc_config {
      subnet_ids = [
        "subnet-aaaaaaaaaaaaaaaaaa",
        "subnet-bbbbbbbbbbbbbbbbbb",
        "subnet-cccccccccccccccccc",
      ]

      security_groups_ids = [
        "sg-yyyyyyyyyyyyyyyyy",
      ]
    }
  }

  #---------------------------------------------------------------
  # replication_info_list ブロック (Required)
  #---------------------------------------------------------------
  # ソースクラスターからターゲットクラスターへのレプリケーションフローを定義します。
  # 1つのreplication_info_listブロックのみ指定可能です。

  replication_info_list {
    # (Required) ソースKafkaクラスターのARN
    # kafka_clusterブロックで定義したクラスターのうち、
    # レプリケーションのソース（データ読み取り元）となるクラスターのARNを指定します。
    source_kafka_cluster_arn = "arn:aws:kafka:us-east-1:123456789012:cluster/source-cluster/12345678-1234-1234-1234-123456789012-1"

    # (Required) ターゲットKafkaクラスターのARN
    # kafka_clusterブロックで定義したクラスターのうち、
    # レプリケーションのターゲット（データ書き込み先）となるクラスターのARNを指定します。
    target_kafka_cluster_arn = "arn:aws:kafka:ap-northeast-1:123456789012:cluster/target-cluster/87654321-4321-4321-4321-210987654321-1"

    # (Required) ターゲットクラスターへの書き込み時の圧縮タイプ
    # 指定可能な値:
    #   - "NONE"   : 圧縮なし
    #   - "GZIP"   : GZIP圧縮
    #   - "SNAPPY" : Snappy圧縮
    #   - "LZ4"    : LZ4圧縮
    #   - "ZSTD"   : Zstandard圧縮
    target_compression_type = "NONE"

    #---------------------------------------------------------------
    # topic_replication ブロック (Required)
    #---------------------------------------------------------------
    # トピックレプリケーションの設定を定義します。
    # 1つ以上のtopic_replicationブロックを指定する必要があります。

    topic_replication {
      # (Required) レプリケート対象のトピックを指定する正規表現パターンのリスト
      # 例: [".*"] はすべてのトピックをレプリケート
      # 例: ["^orders-.*", "^payments-.*"] は特定のプレフィックスを持つトピックのみ
      topics_to_replicate = [".*"]

      # (Optional) レプリケートから除外するトピックを指定する正規表現パターンのリスト
      # topics_to_replicateでマッチしたトピックのうち、
      # ここで指定したパターンにマッチするトピックは除外されます。
      # 例: ["^__.*", "^_schemas"] は内部トピックを除外
      # topics_to_exclude = ["^__.*"]

      # (Optional) 新しいトピックとパーティションの自動検出・コピーを有効にするか
      # trueの場合、ソースクラスターに新しいトピックやパーティションが作成されると
      # 自動的にターゲットクラスターにもコピーされます。
      # 注意: 新しいトピックの検出には最大30秒かかる場合があります。
      # デフォルト: true
      detect_and_copy_new_topics = true

      # (Optional) トピックACLのリモートコピーを有効にするか
      # trueの場合、ソースクラスターのトピックACLをターゲットクラスターにコピーします。
      # 注意: LITERALパターンタイプのACLのみコピーされます。
      # PREFIXEDパターンタイプや他のリソースタイプのACLはコピーされません。
      # デフォルト: true
      copy_access_control_lists_for_topics = true

      # (Optional) トピック設定のコピーを有効にするか
      # trueの場合、ソースクラスターのトピック設定（retention.ms等）を
      # ターゲットクラスターにコピーします。
      # デフォルト: true
      copy_topic_configurations = true

      # (Optional) トピック名の設定
      # レプリケートされたトピックの名前をどのように構成するかを指定します。
      topic_name_configuration {
        # (Optional) トピック名設定のタイプ
        # 指定可能な値:
        #   - "PREFIXED_WITH_SOURCE_CLUSTER_ALIAS" (デフォルト):
        #       ターゲットクラスターのトピック名にソースクラスターのエイリアスが
        #       プレフィックスとして付加されます（例: sourceAlias.topicName）
        #       アクティブ-アクティブ構成で推奨されます。
        #   - "IDENTICAL":
        #       ソースクラスターと同じトピック名を使用します。
        #       フェイルオーバー時のクライアント再設定が不要になります。
        #       無限レプリケーションループを防ぐためKafkaヘッダーが使用されます。
        type = "PREFIXED_WITH_SOURCE_CLUSTER_ALIAS"
      }

      # (Optional) レプリケーション開始位置の設定
      # 新しいトピックのレプリケーションをどの位置から開始するかを指定します。
      starting_position {
        # (Optional) レプリケーション開始位置のタイプ
        # 指定可能な値:
        #   - "LATEST" (デフォルト):
        #       最新のオフセットからレプリケーションを開始します。
        #       Replicator作成後に生成されたメッセージのみがレプリケートされます。
        #   - "EARLIEST":
        #       最も古いオフセットからレプリケーションを開始します。
        #       既存のメッセージもすべてレプリケートされます。
        #       クラスター移行時に推奨されます。
        type = "LATEST"
      }
    }

    #---------------------------------------------------------------
    # consumer_group_replication ブロック (Required)
    #---------------------------------------------------------------
    # コンシューマーグループのレプリケーション設定を定義します。
    # 1つ以上のconsumer_group_replicationブロックを指定する必要があります。

    consumer_group_replication {
      # (Required) レプリケート対象のコンシューマーグループを指定する正規表現パターンのリスト
      # 例: [".*"] はすべてのコンシューマーグループをレプリケート
      # 例: ["^app-.*"] は特定のプレフィックスを持つグループのみ
      consumer_groups_to_replicate = [".*"]

      # (Optional) レプリケートから除外するコンシューマーグループを指定する正規表現パターンのリスト
      # consumer_groups_to_replicateでマッチしたグループのうち、
      # ここで指定したパターンにマッチするグループは除外されます。
      # consumer_groups_to_exclude = ["^internal-.*"]

      # (Optional) 新しいコンシューマーグループの自動検出・コピーを有効にするか
      # trueの場合、ソースクラスターに新しいコンシューマーグループが作成されると
      # 自動的にターゲットクラスターにもコピーされます。
      # デフォルト: true
      detect_and_copy_new_consumer_groups = true

      # (Optional) コンシューマーグループオフセットの同期を有効にするか
      # trueの場合、ソースクラスターのコンシューマーグループオフセットを
      # ターゲットクラスターの__consumer_offsetsトピックに定期的に書き込みます。
      # これにより、フェイルオーバー後にコンシューマーが適切な位置から再開できます。
      # 注意: ソースクラスターでラグがあるコンシューマーグループは、
      # ターゲットでより高いラグが発生する可能性があります。
      # デフォルト: true
      synchronise_consumer_group_offsets = true
    }
  }

  #---------------------------------------------------------------
  # timeouts ブロック (Optional)
  #---------------------------------------------------------------
  # リソース操作のタイムアウト時間を設定します。
  # MSK Replicatorの作成には数分かかる場合があります。

  timeouts {
    # (Optional) リソース作成のタイムアウト
    # Replicatorの作成と必要なリソースのデプロイにかかる最大時間を指定します。
    # デフォルト: "30m"
    create = "60m"

    # (Optional) リソース更新のタイムアウト
    # Replicator設定の更新にかかる最大時間を指定します。
    # デフォルト: "30m"
    update = "60m"

    # (Optional) リソース削除のタイムアウト
    # Replicatorの削除とクリーンアップにかかる最大時間を指定します。
    # デフォルト: "30m"
    delete = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能ですが、
# Terraform設定ファイルでは指定できません（computed only）。
#
# arn
#   - ReplicatorのARN
#   - 例: "arn:aws:kafka:ap-northeast-1:123456789012:replicator/example-replicator/12345678-1234-1234-1234-123456789012"
#
# current_version
#   - Replicatorの現在のバージョン
#   - 更新操作時に使用されます
#
# tags_all
#   - プロバイダーレベルの default_tags を含む、リソースに割り当てられた全タグのマップ
#
# replication_info_list[*].source_kafka_cluster_alias
#   - ソースKafkaクラスターのエイリアス
#   - PREFIXED_WITH_SOURCE_CLUSTER_ALIASモード時にトピック名のプレフィックスとして使用されます
#
# replication_info_list[*].target_kafka_cluster_alias
#   - ターゲットKafkaクラスターのエイリアス
#---------------------------------------------------------------
