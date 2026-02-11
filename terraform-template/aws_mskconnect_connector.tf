#---------------------------------------------------------------
# AWS MSK Connect Connector
#---------------------------------------------------------------
#
# Amazon MSK Connectコネクタをプロビジョニングするリソース。
# MSK Connectは、Apache Kafka Connectフレームワークを使用して
# Apache Kafkaクラスターとの間でストリーミングデータを移動することを
# 簡素化するAmazon MSKの機能です。
#
# AWS公式ドキュメント:
#   - MSK Connect概要: https://docs.aws.amazon.com/msk/latest/developerguide/msk-connect.html
#   - CreateConnector API: https://docs.aws.amazon.com/MSKC/latest/mskc/API_CreateConnector.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mskconnect_connector
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_mskconnect_connector" "this" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # (Required) コネクタの名前
  # コネクタを識別するための一意の名前を指定します。
  name = "example-connector"

  # (Required) Kafka Connectのバージョン
  # Apache KafkaクラスターおよびプラグインのバージョンとCompatibleである
  # 必要があります。
  # 例: "2.7.1"
  kafkaconnect_version = "2.7.1"

  # (Required) コネクタの構成
  # コネクタの動作を定義するキーと値のペアのマップ。
  # connector.class: 使用するコネクタクラス
  # tasks.max: 並列実行するタスクの最大数
  # topics: ソース/シンクとして使用するKafkaトピック
  connector_configuration = {
    "connector.class" = "com.github.jcustenborder.kafka.connect.simulator.SimulatorSinkConnector"
    "tasks.max"       = "1"
    "topics"          = "example-topic"
  }

  # (Required) コネクタで使用するIAMロールのARN
  # コネクタがAWSリソースにアクセスするために必要な権限を持つIAMロール。
  # 例: S3宛先の場合はS3への書き込み権限が必要。
  service_execution_role_arn = "arn:aws:iam::123456789012:role/msk-connect-role"

  # (Optional) コネクタの説明
  # コネクタの目的や用途を説明するテキスト。
  description = "Example MSK Connect connector"

  # (Optional) リソースを管理するAWSリージョン
  # 省略した場合、プロバイダー設定のリージョンが使用されます。
  # region = "ap-northeast-1"

  # (Optional) リソースに割り当てるタグ
  # provider の default_tags が設定されている場合、
  # 同じキーのタグはここで定義したものが優先されます。
  tags = {
    Environment = "production"
    Project     = "data-pipeline"
  }

  #---------------------------------------------------------------
  # capacity ブロック (Required)
  #---------------------------------------------------------------
  # コネクタに割り当てる容量の情報。
  # autoscaling または provisioned_capacity のいずれか一方を指定します。

  capacity {
    #---------------------------------------------------------------
    # autoscaling ブロック (Optional)
    #---------------------------------------------------------------
    # オートスケーリングを使用する場合の設定。
    # ワーカー数が負荷に応じて自動的にスケールします。

    autoscaling {
      # (Required) 割り当てる最小ワーカー数
      min_worker_count = 1

      # (Required) 割り当てる最大ワーカー数
      max_worker_count = 2

      # (Optional) 各ワーカーに割り当てるMCU（Microcontroller Unit）数
      # 有効な値: 1, 2, 4, 8
      # デフォルト: 1
      mcu_count = 1

      # (Optional) スケールインポリシー
      # ワーカー数を減らす条件を定義します。
      scale_in_policy {
        # (Optional, Computed) スケールインをトリガーするCPU使用率の閾値（%）
        cpu_utilization_percentage = 20
      }

      # (Optional) スケールアウトポリシー
      # ワーカー数を増やす条件を定義します。
      scale_out_policy {
        # (Optional, Computed) スケールアウトをトリガーするCPU使用率の閾値（%）
        cpu_utilization_percentage = 80
      }
    }

    #---------------------------------------------------------------
    # provisioned_capacity ブロック (Optional)
    #---------------------------------------------------------------
    # 固定容量を使用する場合の設定。
    # autoscaling と同時に指定することはできません。

    # provisioned_capacity {
    #   # (Required) 割り当てるワーカー数
    #   worker_count = 2

    #   # (Optional) 各ワーカーに割り当てるMCU数
    #   # 有効な値: 1, 2, 4, 8
    #   # デフォルト: 1
    #   mcu_count = 1
    # }
  }

  #---------------------------------------------------------------
  # kafka_cluster ブロック (Required)
  #---------------------------------------------------------------
  # 接続先のApache Kafkaクラスターの設定。

  kafka_cluster {
    # (Required) Apache Kafkaクラスターの設定
    apache_kafka_cluster {
      # (Required) クラスターのブートストラップサーバー
      # カンマ区切りの host:port 形式で指定します。
      bootstrap_servers = "b-1.example.xxx.kafka.ap-northeast-1.amazonaws.com:9094"

      # (Required) VPC設定
      vpc {
        # (Required) コネクタで使用するセキュリティグループ
        security_groups = ["sg-0123456789abcdef0"]

        # (Required) コネクタで使用するサブネット
        # Kafkaクラスターへのネットワーク接続性を持つサブネットを指定します。
        subnets = [
          "subnet-0123456789abcdef0",
          "subnet-0123456789abcdef1",
          "subnet-0123456789abcdef2"
        ]
      }
    }
  }

  #---------------------------------------------------------------
  # kafka_cluster_client_authentication ブロック (Required)
  #---------------------------------------------------------------
  # Apache Kafkaクラスターへのクライアント認証の設定。

  kafka_cluster_client_authentication {
    # (Optional) クライアント認証のタイプ
    # 有効な値: "IAM", "NONE"
    # デフォルト: "NONE"
    authentication_type = "NONE"
  }

  #---------------------------------------------------------------
  # kafka_cluster_encryption_in_transit ブロック (Required)
  #---------------------------------------------------------------
  # Apache Kafkaクラスターへの転送中暗号化の設定。

  kafka_cluster_encryption_in_transit {
    # (Optional) 転送中暗号化のタイプ
    # 有効な値: "PLAINTEXT", "TLS"
    # デフォルト: "PLAINTEXT"
    encryption_type = "TLS"
  }

  #---------------------------------------------------------------
  # plugin ブロック (Required, 1つ以上)
  #---------------------------------------------------------------
  # コネクタで使用するプラグインの設定。
  # 複数のプラグインを指定できます。

  plugin {
    # (Required) カスタムプラグインの設定
    custom_plugin {
      # (Required) カスタムプラグインのARN
      arn = "arn:aws:kafkaconnect:ap-northeast-1:123456789012:custom-plugin/example-plugin/abcd1234-0000-0000-0000-000000000000-1"

      # (Required) カスタムプラグインのリビジョン番号
      revision = 1
    }
  }

  #---------------------------------------------------------------
  # log_delivery ブロック (Optional)
  #---------------------------------------------------------------
  # ログ配信の設定。
  # CloudWatch Logs、Kinesis Data Firehose、S3のいずれかまたは
  # 複数の宛先にログを配信できます。

  log_delivery {
    # (Required) ワーカーログ配信の設定
    worker_log_delivery {

      # (Optional) CloudWatch Logsへのログ配信設定
      cloudwatch_logs {
        # (Required) ログ配信を有効にするかどうか
        enabled = true

        # (Optional) ログ配信先のCloudWatchロググループ名
        # enabled が true の場合に必要です。
        log_group = "/aws/msk-connect/example-connector"
      }

      # (Optional) Kinesis Data Firehoseへのログ配信設定
      # firehose {
      #   # (Required) Firehoseへのログ配信を有効にするかどうか
      #   enabled = false

      #   # (Optional) 配信先のFirehoseストリーム名
      #   # enabled が true の場合に必要です。
      #   delivery_stream = "example-delivery-stream"
      # }

      # (Optional) S3へのログ配信設定
      # s3 {
      #   # (Required) S3へのログ配信を有効にするかどうか
      #   enabled = false

      #   # (Optional) 配信先のS3バケット名
      #   # enabled が true の場合に必要です。
      #   bucket = "example-log-bucket"

      #   # (Optional) S3内のプレフィックス
      #   prefix = "msk-connect-logs/"
      # }
    }
  }

  #---------------------------------------------------------------
  # worker_configuration ブロック (Optional)
  #---------------------------------------------------------------
  # コネクタで使用するワーカー構成の設定。

  # worker_configuration {
  #   # (Required) ワーカー構成のARN
  #   arn = "arn:aws:kafkaconnect:ap-northeast-1:123456789012:worker-configuration/example-worker-config/abcd1234-0000-0000-0000-000000000000-1"

  #   # (Required) ワーカー構成のリビジョン番号
  #   revision = 1
  # }

  #---------------------------------------------------------------
  # timeouts ブロック (Optional)
  #---------------------------------------------------------------
  # 各操作のタイムアウト設定。

  timeouts {
    # (Optional) リソース作成のタイムアウト
    # デフォルトは20分。
    create = "30m"

    # (Optional) リソース更新のタイムアウト
    # デフォルトは20分。
    update = "30m"

    # (Optional) リソース削除のタイムアウト
    # デフォルトは10分。
    delete = "20m"
  }
}

#---------------------------------------------------------------
# Attributes Reference（読み取り専用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computed only）:
#
# arn       - コネクタのAmazon Resource Name (ARN)
# id        - コネクタの識別子
# version   - コネクタの現在のバージョン
# tags_all  - プロバイダーの default_tags を含む全てのタグ
#---------------------------------------------------------------
