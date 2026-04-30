#---------------------------------------------------------------
# Amazon MSK クラスター
#---------------------------------------------------------------
#
# Amazon Managed Streaming for Apache Kafka (MSK) クラスターを
# プロビジョニングするリソースです。
# MSK はフルマネージドの Apache Kafka サービスで、Kafka クラスターの
# セットアップ・スケーリング・管理を自動化します。
# ブローカーノード構成、認証、暗号化、モニタリングなど幅広い設定に対応します。
#
# AWS公式ドキュメント:
#   - Amazon MSK とは: https://docs.aws.amazon.com/msk/latest/developerguide/what-is-msk.html
#   - MSK クラスターの作成: https://docs.aws.amazon.com/msk/latest/developerguide/msk-create-cluster.html
#   - MSK セキュリティ: https://docs.aws.amazon.com/msk/latest/developerguide/MSKSecurity.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster
#
# Provider Version: 6.43.0
# Generated: 2026-04-30
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_msk_cluster" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # cluster_name (Required)
  # 設定内容: MSK クラスターの名前を指定します。
  # 設定可能な値: 1〜64文字の英数字、ハイフン、アンダースコア
  cluster_name = "example-msk-cluster"

  # kafka_version (Required)
  # 設定内容: Apache Kafka のバージョンを指定します。
  # 設定可能な値: "3.5.1", "3.6.0", "3.7.x" 等、MSK でサポートされているバージョン
  #   参考: https://docs.aws.amazon.com/msk/latest/developerguide/supported-kafka-versions.html
  kafka_version = "3.5.1"

  # number_of_broker_nodes (Required)
  # 設定内容: クラスター内のブローカーノード数を指定します。
  # 設定可能な値: client_subnets で指定したサブネット数の倍数（例: 3サブネットなら 3, 6, 9 等）
  # 注意: 高可用性のため、複数 AZ にわたる構成（最低3）を推奨します
  number_of_broker_nodes = 3

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # enhanced_monitoring (Optional)
  # 設定内容: クラスターに対して有効化する拡張モニタリングのレベルを指定します。
  # 設定可能な値:
  #   - "DEFAULT": デフォルトのモニタリングメトリクス
  #   - "PER_BROKER": ブローカーレベルのメトリクスを追加
  #   - "PER_TOPIC_PER_BROKER": トピック・ブローカーごとのメトリクスを追加
  #   - "PER_TOPIC_PER_PARTITION": パーティションレベルのメトリクスを追加（最も詳細）
  # 省略時: "DEFAULT"
  # 注意: モニタリングレベルを上げると追加の CloudWatch コストが発生します
  enhanced_monitoring = "DEFAULT"

  # storage_mode (Optional, Computed)
  # 設定内容: ブローカーのストレージモードを指定します。
  # 設定可能な値:
  #   - "LOCAL": EBS ストレージのみを使用
  #   - "TIERED": ローカル EBS に加えて S3 を階層型ストレージとして使用
  # 省略時: "LOCAL"
  # 注意: TIERED モードは kafka_version 2.8.0 以降でのみサポートされます
  storage_mode = "LOCAL"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  tags = {
    Name        = "example-msk-cluster"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # ブローカーノードグループ設定
  #-------------------------------------------------------------

  # broker_node_group_info (Required)
  # 設定内容: ブローカーノードのグループ情報を指定するブロックです。
  # 注意: このブロックは必須です。
  # 参考: https://docs.aws.amazon.com/msk/latest/developerguide/msk-create-cluster.html
  broker_node_group_info {
    # instance_type (Required)
    # 設定内容: ブローカーノードの EC2 インスタンスタイプを指定します。
    # 設定可能な値: "kafka.t3.small", "kafka.m5.large", "kafka.m5.xlarge",
    #   "kafka.m5.2xlarge", "kafka.m5.4xlarge", "kafka.m5.8xlarge",
    #   "kafka.m5.12xlarge", "kafka.m5.16xlarge", "kafka.m5.24xlarge" 等
    #   参考: https://docs.aws.amazon.com/msk/latest/developerguide/msk-create-cluster.html
    instance_type = "kafka.m5.large"

    # client_subnets (Required)
    # 設定内容: ブローカーノードを配置するサブネット ID のセットを指定します。
    # 設定可能な値: 有効なサブネット ID のセット
    # 注意: 高可用性のため、異なる AZ のサブネットを指定することを強く推奨します。
    #       number_of_broker_nodes はここで指定するサブネット数の倍数である必要があります。
    client_subnets = [
      "subnet-11111111",
      "subnet-22222222",
      "subnet-33333333",
    ]

    # security_groups (Required)
    # 設定内容: ブローカーノードに関連付けるセキュリティグループ ID のセットを指定します。
    # 設定可能な値: 有効なセキュリティグループ ID のセット
    security_groups = ["sg-12345678"]

    # az_distribution (Optional)
    # 設定内容: ブローカーノードを複数 AZ に分散させる方法を指定します。
    # 設定可能な値:
    #   - "DEFAULT": AWS がブローカーノードを利用可能な AZ に均等に分散
    # 省略時: "DEFAULT"
    az_distribution = "DEFAULT"

    # connectivity_info (Optional)
    # 設定内容: ブローカーの接続設定を指定するブロックです。
    # パブリックアクセスや VPC 接続のオプションを設定します。
    connectivity_info {
      # network_type (Optional, Computed)
      # 設定内容: ブローカーノードに割り当てるネットワークタイプを指定します。
      # 設定可能な値:
      #   - "SINGLE_VPC": 単一 VPC でのアクセス（IPv4）
      #   - "DUAL_STACK": IPv4 と IPv6 の両方をサポートするデュアルスタック構成
      # 省略時: AWS 側でデフォルトのネットワークタイプが設定されます
      # 注意: DUAL_STACK を有効化するには、サブネットとセキュリティグループが
      #       IPv6 をサポートしている必要があります。
      # 参考: https://docs.aws.amazon.com/msk/latest/developerguide/ipv6-and-msk.html
      network_type = "SINGLE_VPC"

      # public_access (Optional)
      # 設定内容: ブローカーへのパブリックアクセスを制御するブロックです。
      public_access {
        # type (Optional, Computed)
        # 設定内容: パブリックアクセスの有効化状態を指定します。
        # 設定可能な値:
        #   - "DISABLED": パブリックアクセスを無効化（デフォルト）
        #   - "SERVICE_PROVIDED_EIPS": AWS が提供する Elastic IP アドレスを使用
        # 省略時: "DISABLED"
        # 注意: パブリックアクセスを有効化する場合は encryption_info での TLS 設定が必要です
        type = "DISABLED"
      }

      # vpc_connectivity (Optional)
      # 設定内容: VPC 接続設定を指定するブロックです。
      # 他の VPC からクライアント認証を設定してブローカーに接続できます。
      vpc_connectivity {
        # client_authentication (Optional)
        # 設定内容: VPC 接続でのクライアント認証設定を指定するブロックです。
        client_authentication {
          # tls (Optional, Computed)
          # 設定内容: VPC 接続での TLS クライアント認証を有効化するかを指定します。
          # 設定可能な値: true, false
          # 省略時: false
          tls = false

          # sasl (Optional)
          # 設定内容: VPC 接続での SASL 認証設定を指定するブロックです。
          sasl {
            # iam (Optional, Computed)
            # 設定内容: VPC 接続での IAM 認証を有効化するかを指定します。
            # 設定可能な値: true, false
            # 省略時: false
            iam = false

            # scram (Optional, Computed)
            # 設定内容: VPC 接続での SCRAM 認証を有効化するかを指定します。
            # 設定可能な値: true, false
            # 省略時: false
            scram = false
          }
        }
      }
    }

    # storage_info (Optional)
    # 設定内容: ブローカーノードのストレージ設定を指定するブロックです。
    storage_info {
      # ebs_storage_info (Optional)
      # 設定内容: ブローカーノードの EBS ストレージ設定を指定するブロックです。
      ebs_storage_info {
        # volume_size (Optional)
        # 設定内容: ブローカーノードあたりの EBS ボリュームサイズを GiB 単位で指定します。
        # 設定可能な値: 1〜16384 (GiB)
        # 省略時: 1 GiB
        volume_size = 100

        # provisioned_throughput (Optional)
        # 設定内容: EBS ボリュームのプロビジョンドスループット設定を指定するブロックです。
        # 参考: https://docs.aws.amazon.com/msk/latest/developerguide/msk-provision-throughput.html
        provisioned_throughput {
          # enabled (Optional)
          # 設定内容: プロビジョンドスループットを有効化するかを指定します。
          # 設定可能な値: true, false
          # 省略時: false
          # 注意: kafka.t3.small インスタンスタイプではサポートされていません
          enabled = true

          # volume_throughput (Optional)
          # 設定内容: ブローカーノードあたりの EBS ボリュームスループットを MiB/秒 単位で指定します。
          # 設定可能な値: 250〜2375 (MiB/秒)
          # 省略時: enabled = true の場合は設定が必要
          volume_throughput = 250
        }
      }
    }
  }

  #-------------------------------------------------------------
  # クライアント認証設定
  #-------------------------------------------------------------

  # client_authentication (Optional)
  # 設定内容: MSK クラスターへのクライアント認証設定を指定するブロックです。
  # 参考: https://docs.aws.amazon.com/msk/latest/developerguide/msk-authentication.html
  client_authentication {
    # unauthenticated (Optional)
    # 設定内容: 認証なしのクライアントアクセスを許可するかを指定します。
    # 設定可能な値: true, false
    # 省略時: false
    # 注意: 本番環境では false を推奨します
    unauthenticated = false

    # sasl (Optional)
    # 設定内容: SASL 認証設定を指定するブロックです。
    sasl {
      # iam (Optional)
      # 設定内容: IAM ロールベースの認証を有効化するかを指定します。
      # 設定可能な値: true, false
      # 省略時: false
      # 注意: IAM 認証を有効化する場合は encryption_in_transit.client_broker を
      #       "TLS" または "TLS_PLAINTEXT" に設定する必要があります
      iam = true

      # scram (Optional)
      # 設定内容: SASL/SCRAM 認証を有効化するかを指定します。
      # 設定可能な値: true, false
      # 省略時: false
      # 注意: SCRAM 認証を使用する場合は AWS Secrets Manager と連携が必要です
      scram = false
    }

    # tls (Optional)
    # 設定内容: TLS クライアント認証設定を指定するブロックです。
    tls {
      # certificate_authority_arns (Optional)
      # 設定内容: クライアント証明書の検証に使用する AWS Certificate Manager (ACM) の
      #          プライベート CA の ARN セットを指定します。
      # 設定可能な値: 有効な ACM プライベート CA の ARN セット
      # 省略時: 証明書検証なし
      certificate_authority_arns = []
    }
  }

  #-------------------------------------------------------------
  # MSK 設定情報
  #-------------------------------------------------------------

  # configuration_info (Optional)
  # 設定内容: MSK クラスターに適用する MSK 設定の情報を指定するブロックです。
  # 参考: https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration.html
  configuration_info {
    # arn (Required)
    # 設定内容: 適用する MSK 設定の ARN を指定します。
    # 設定可能な値: 有効な MSK 設定の ARN
    arn = "arn:aws:kafka:ap-northeast-1:123456789012:configuration/example-config/abcd1234-1234-1234-1234-abcdef123456-1"

    # revision (Required)
    # 設定内容: 適用する MSK 設定のリビジョン番号を指定します。
    # 設定可能な値: 有効なリビジョン番号（正の整数）
    revision = 1
  }

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # encryption_info (Optional)
  # 設定内容: MSK クラスターの暗号化設定を指定するブロックです。
  # 参考: https://docs.aws.amazon.com/msk/latest/developerguide/msk-encryption.html
  encryption_info {
    # encryption_at_rest_kms_key_arn (Optional, Computed)
    # 設定内容: 保存データの暗号化に使用する KMS キーの ARN を指定します。
    # 設定可能な値: 有効な KMS キーの ARN
    # 省略時: AWS マネージドキー (aws/kafka) を使用して暗号化
    encryption_at_rest_kms_key_arn = null

    # encryption_in_transit (Optional)
    # 設定内容: 転送中データの暗号化設定を指定するブロックです。
    encryption_in_transit {
      # client_broker (Optional)
      # 設定内容: クライアントとブローカー間の転送中暗号化の設定を指定します。
      # 設定可能な値:
      #   - "TLS": TLS 暗号化のみを許可（推奨）
      #   - "TLS_PLAINTEXT": TLS 暗号化と平文の両方を許可
      #   - "PLAINTEXT": 平文のみを許可
      # 省略時: "PLAINTEXT"
      # 注意: セキュリティのため本番環境では "TLS" を推奨します
      client_broker = "TLS"

      # in_cluster (Optional)
      # 設定内容: ブローカーノード間の転送中暗号化を有効化するかを指定します。
      # 設定可能な値: true, false
      # 省略時: true
      in_cluster = true
    }
  }

  #-------------------------------------------------------------
  # ログ設定
  #-------------------------------------------------------------

  # logging_info (Optional)
  # 設定内容: MSK クラスターのブローカーログ設定を指定するブロックです。
  # 参考: https://docs.aws.amazon.com/msk/latest/developerguide/msk-logging.html
  logging_info {
    # broker_logs (Required)
    # 設定内容: ブローカーログの送信先を指定するブロックです。
    broker_logs {
      # cloudwatch_logs (Optional)
      # 設定内容: CloudWatch Logs へのログ送信設定を指定するブロックです。
      cloudwatch_logs {
        # enabled (Required)
        # 設定内容: CloudWatch Logs へのログ送信を有効化するかを指定します。
        # 設定可能な値: true, false
        enabled = true

        # log_group (Optional)
        # 設定内容: ログの送信先 CloudWatch Logs グループ名を指定します。
        # 設定可能な値: 有効な CloudWatch Logs グループ名
        # 省略時: enabled = true の場合は指定が必要
        log_group = "/aws/msk/cluster/example"
      }

      # firehose (Optional)
      # 設定内容: Amazon Kinesis Data Firehose へのログ送信設定を指定するブロックです。
      firehose {
        # enabled (Required)
        # 設定内容: Kinesis Data Firehose へのログ送信を有効化するかを指定します。
        # 設定可能な値: true, false
        enabled = false

        # delivery_stream (Optional)
        # 設定内容: ログの送信先 Kinesis Data Firehose 配信ストリーム名を指定します。
        # 設定可能な値: 有効な Kinesis Data Firehose 配信ストリーム名
        # 省略時: enabled = true の場合は指定が必要
        delivery_stream = null
      }

      # s3 (Optional)
      # 設定内容: Amazon S3 へのログ送信設定を指定するブロックです。
      s3 {
        # enabled (Required)
        # 設定内容: S3 へのログ送信を有効化するかを指定します。
        # 設定可能な値: true, false
        enabled = false

        # bucket (Optional)
        # 設定内容: ログの送信先 S3 バケット名を指定します。
        # 設定可能な値: 有効な S3 バケット名
        # 省略時: enabled = true の場合は指定が必要
        bucket = null

        # prefix (Optional)
        # 設定内容: ログオブジェクトの S3 キープレフィックスを指定します。
        # 設定可能な値: 任意の文字列
        # 省略時: プレフィックスなし
        prefix = null
      }
    }
  }

  #-------------------------------------------------------------
  # オープンモニタリング設定
  #-------------------------------------------------------------

  # open_monitoring (Optional)
  # 設定内容: Prometheus によるオープンモニタリング設定を指定するブロックです。
  # JMX Exporter および Node Exporter を使用した Prometheus メトリクス収集を設定します。
  # 参考: https://docs.aws.amazon.com/msk/latest/developerguide/open-monitoring.html
  open_monitoring {
    # prometheus (Required)
    # 設定内容: Prometheus エクスポーターの設定を指定するブロックです。
    prometheus {
      # jmx_exporter (Optional)
      # 設定内容: JMX Exporter による Kafka メトリクス収集設定を指定するブロックです。
      jmx_exporter {
        # enabled_in_broker (Required)
        # 設定内容: ブローカーで JMX Exporter を有効化するかを指定します。
        # 設定可能な値: true, false
        enabled_in_broker = true
      }

      # node_exporter (Optional)
      # 設定内容: Node Exporter によるノードメトリクス収集設定を指定するブロックです。
      node_exporter {
        # enabled_in_broker (Required)
        # 設定内容: ブローカーで Node Exporter を有効化するかを指定します。
        # 設定可能な値: true, false
        enabled_in_broker = true
      }
    }
  }

  #-------------------------------------------------------------
  # パーティションリバランス設定
  #-------------------------------------------------------------

  # rebalancing (Optional)
  # 設定内容: クラスターのパーティションリバランス設定を指定するブロックです。
  # 参考: https://docs.aws.amazon.com/msk/latest/developerguide/msk-autoexpansion.html
  rebalancing {
    # status (Required)
    # 設定内容: パーティションの自動リバランスの有効化状態を指定します。
    # 設定可能な値:
    #   - "ENABLED": パーティションの自動リバランスを有効化
    #   - "DISABLED": パーティションの自動リバランスを無効化
    status = "DISABLED"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 注意: MSK クラスターの作成・更新・削除には数十分かかる場合があります
  timeouts {
    # create (Optional)
    # 設定内容: クラスターの作成操作のタイムアウト時間を指定します。
    # 設定可能な値: Go の時間パース形式（例: "120m", "2h"）
    # 省略時: Terraform のデフォルトタイムアウトを使用
    create = "120m"

    # update (Optional)
    # 設定内容: クラスターの更新操作のタイムアウト時間を指定します。
    # 設定可能な値: Go の時間パース形式（例: "120m", "2h"）
    # 省略時: Terraform のデフォルトタイムアウトを使用
    update = "120m"

    # delete (Optional)
    # 設定内容: クラスターの削除操作のタイムアウト時間を指定します。
    # 設定可能な値: Go の時間パース形式（例: "120m", "2h"）
    # 省略時: Terraform のデフォルトタイムアウトを使用
    delete = "120m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn / id: MSK クラスターの ARN
# - cluster_uuid: MSK クラスターの UUID
# - current_version: クラスターの現在のバージョン（更新時に使用）
# - bootstrap_brokers: PLAINTEXT 接続用ブートストラップブローカーの接続文字列
# - bootstrap_brokers_tls: TLS 接続用ブートストラップブローカーの接続文字列
# - bootstrap_brokers_sasl_iam: IAM 認証接続用ブートストラップブローカーの接続文字列
# - bootstrap_brokers_sasl_scram: SCRAM 認証接続用ブートストラップブローカーの接続文字列
# - bootstrap_brokers_public_sasl_iam: IAM 認証パブリック接続用ブートストラップブローカー文字列
# - bootstrap_brokers_public_sasl_scram: SCRAM 認証パブリック接続用ブートストラップブローカー文字列
# - bootstrap_brokers_public_tls: TLS パブリック接続用ブートストラップブローカー文字列
# - bootstrap_brokers_vpc_connectivity_sasl_iam: VPC 接続 IAM 認証用ブートストラップブローカー文字列
# - bootstrap_brokers_vpc_connectivity_sasl_scram: VPC 接続 SCRAM 認証用ブートストラップブローカー文字列
# - bootstrap_brokers_vpc_connectivity_tls: VPC 接続 TLS 用ブートストラップブローカー文字列
# - zookeeper_connect_string: ZooKeeper 接続文字列（PLAINTEXT）
# - zookeeper_connect_string_tls: ZooKeeper 接続文字列（TLS）
# - tags_all: プロバイダーの default_tags から継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
