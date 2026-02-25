#---------------------------------------------------------------
# Amazon MSK Connect コネクター
#---------------------------------------------------------------
#
# Amazon MSK Connect のコネクターリソースを管理します。
# MSK Connect は Apache Kafka Connect フレームワークを使用して、
# Amazon MSK クラスターと外部システム間のデータ連携を実現します。
# カスタムプラグインを使用してコネクターを設定し、
# 自動スケーリングまたはプロビジョニングした容量を指定できます。
#
# AWS公式ドキュメント:
#   - Amazon MSK Connect とは: https://docs.aws.amazon.com/msk/latest/developerguide/msk-connect.html
#   - コネクターの作成: https://docs.aws.amazon.com/msk/latest/developerguide/msk-connect-connectors.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mskconnect_connector
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_mskconnect_connector" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: コネクターの名前を指定します。
  # 設定可能な値: 1〜128文字の英数字、ハイフン、アンダースコア
  name = "example-mskconnect-connector"

  # kafkaconnect_version (Required)
  # 設定内容: 使用する Apache Kafka Connect のバージョンを指定します。
  # 設定可能な値: MSK Connect でサポートされているバージョン（例: "2.7.1"）
  kafkaconnect_version = "2.7.1"

  # connector_configuration (Required)
  # 設定内容: コネクターの設定パラメーターをキーと値のマップで指定します。
  # 設定可能な値: コネクタープラグインが受け付ける設定キーと値のマップ
  # 注意: 使用するプラグインの仕様に従って設定値を指定してください
  connector_configuration = {
    "connector.class"                = "com.example.Connector"
    "tasks.max"                      = "2"
    "topics"                         = "example-topic"
  }

  # service_execution_role_arn (Required)
  # 設定内容: コネクターが AWS サービスにアクセスする際に使用する IAM ロールの ARN を指定します。
  # 設定可能な値: 有効な IAM ロールの ARN
  # 注意: ロールには MSK クラスターへのアクセスや必要な AWS サービスへの権限が必要です
  service_execution_role_arn = "arn:aws:iam::123456789012:role/example-mskconnect-role"

  # description (Optional)
  # 設定内容: コネクターの説明を指定します。
  # 設定可能な値: 任意の文字列（最大1024文字）
  # 省略時: 説明なし
  description = "Example MSK Connect connector"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  tags = {
    Name        = "example-mskconnect-connector"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # 容量設定
  #-------------------------------------------------------------

  # capacity (Required)
  # 設定内容: コネクターのスケーリング容量設定を指定するブロックです。
  # 注意: autoscaling または provisioned_capacity のいずれか一方のみ指定できます
  capacity {
    # autoscaling (Optional)
    # 設定内容: コネクターの自動スケーリング設定を指定するブロックです。
    # 注意: provisioned_capacity と同時に指定することはできません
    autoscaling {
      # min_worker_count (Required)
      # 設定内容: 自動スケーリング時のワーカーの最小数を指定します。
      # 設定可能な値: 1 以上の整数
      min_worker_count = 1

      # max_worker_count (Required)
      # 設定内容: 自動スケーリング時のワーカーの最大数を指定します。
      # 設定可能な値: min_worker_count 以上の整数（最大10）
      max_worker_count = 2

      # mcu_count (Optional)
      # 設定内容: ワーカーあたりの MSK Connect Unit (MCU) 数を指定します。
      # 設定可能な値: 1, 2, 4, 8
      # 省略時: 1
      mcu_count = 1

      # scale_in_policy (Optional)
      # 設定内容: スケールイン（縮小）時のポリシーを指定するブロックです。
      scale_in_policy {
        # cpu_utilization_percentage (Optional, Computed)
        # 設定内容: スケールインをトリガーする CPU 使用率の閾値（%）を指定します。
        # 設定可能な値: 1〜100 の整数
        # 省略時: AWS が自動的にデフォルト値を設定
        cpu_utilization_percentage = 20
      }

      # scale_out_policy (Optional)
      # 設定内容: スケールアウト（拡張）時のポリシーを指定するブロックです。
      scale_out_policy {
        # cpu_utilization_percentage (Optional, Computed)
        # 設定内容: スケールアウトをトリガーする CPU 使用率の閾値（%）を指定します。
        # 設定可能な値: 1〜100 の整数
        # 省略時: AWS が自動的にデフォルト値を設定
        cpu_utilization_percentage = 80
      }
    }

    # provisioned_capacity (Optional)
    # 設定内容: コネクターのプロビジョニング容量設定を指定するブロックです。
    # 注意: autoscaling と同時に指定することはできません。このブロックを使用する場合は
    #       autoscaling ブロックをコメントアウトしてください
    # provisioned_capacity {
    #   # worker_count (Required)
    #   # 設定内容: ワーカーの数を指定します。
    #   # 設定可能な値: 1〜10 の整数
    #   worker_count = 1
    #
    #   # mcu_count (Optional)
    #   # 設定内容: ワーカーあたりの MSK Connect Unit (MCU) 数を指定します。
    #   # 設定可能な値: 1, 2, 4, 8
    #   # 省略時: 1
    #   mcu_count = 1
    # }
  }

  #-------------------------------------------------------------
  # Kafka クラスター接続設定
  #-------------------------------------------------------------

  # kafka_cluster (Required)
  # 設定内容: コネクターが接続する Apache Kafka クラスターの設定を指定するブロックです。
  kafka_cluster {
    # apache_kafka_cluster (Required)
    # 設定内容: Apache Kafka クラスターの接続詳細を指定するブロックです。
    apache_kafka_cluster {
      # bootstrap_servers (Required)
      # 設定内容: Kafka ブローカーへの接続に使用するブートストラップサーバーの一覧を指定します。
      # 設定可能な値: "broker1:9092,broker2:9092" 形式の接続文字列
      bootstrap_servers = "b-1.example.abc123.kafka.ap-northeast-1.amazonaws.com:9092,b-2.example.abc123.kafka.ap-northeast-1.amazonaws.com:9092"

      # vpc (Required)
      # 設定内容: Kafka クラスターが配置されている VPC の設定を指定するブロックです。
      vpc {
        # security_groups (Required)
        # 設定内容: コネクターワーカーに関連付けるセキュリティグループ ID のセットを指定します。
        # 設定可能な値: 有効なセキュリティグループ ID のセット
        security_groups = ["sg-12345678"]

        # subnets (Required)
        # 設定内容: コネクターワーカーを配置するサブネット ID のセットを指定します。
        # 設定可能な値: 有効なサブネット ID のセット
        # 注意: 高可用性のため、複数の AZ にまたがるサブネットを指定することを推奨します
        subnets = [
          "subnet-11111111",
          "subnet-22222222",
          "subnet-33333333",
        ]
      }
    }
  }

  #-------------------------------------------------------------
  # Kafka クラスタークライアント認証設定
  #-------------------------------------------------------------

  # kafka_cluster_client_authentication (Required)
  # 設定内容: Kafka クラスターへのクライアント認証設定を指定するブロックです。
  kafka_cluster_client_authentication {
    # authentication_type (Optional)
    # 設定内容: Kafka クラスターへの接続に使用する認証タイプを指定します。
    # 設定可能な値:
    #   - "NONE": 認証なし
    #   - "IAM": AWS IAM 認証
    # 省略時: "NONE"
    authentication_type = "NONE"
  }

  #-------------------------------------------------------------
  # Kafka クラスター転送中暗号化設定
  #-------------------------------------------------------------

  # kafka_cluster_encryption_in_transit (Required)
  # 設定内容: Kafka クラスターへの接続における転送中暗号化設定を指定するブロックです。
  kafka_cluster_encryption_in_transit {
    # encryption_type (Optional)
    # 設定内容: Kafka クラスターとコネクター間の転送中暗号化のタイプを指定します。
    # 設定可能な値:
    #   - "PLAINTEXT": 平文（暗号化なし）
    #   - "TLS": TLS 暗号化（推奨）
    # 省略時: "PLAINTEXT"
    # 注意: 本番環境ではセキュリティのため "TLS" を推奨します
    encryption_type = "PLAINTEXT"
  }

  #-------------------------------------------------------------
  # プラグイン設定
  #-------------------------------------------------------------

  # plugin (Required, Set)
  # 設定内容: コネクターが使用するカスタムプラグインを指定するブロックです。
  # 注意: 少なくとも1つのプラグインを指定する必要があります
  plugin {
    # custom_plugin (Required)
    # 設定内容: カスタムプラグインの参照を指定するブロックです。
    custom_plugin {
      # arn (Required)
      # 設定内容: 使用するカスタムプラグインの ARN を指定します。
      # 設定可能な値: 有効な MSK Connect カスタムプラグインの ARN
      arn = "arn:aws:kafkaconnect:ap-northeast-1:123456789012:custom-plugin/example-plugin/abcd1234-1234-1234-1234-abcdef123456-1"

      # revision (Required)
      # 設定内容: 使用するカスタムプラグインのリビジョン番号を指定します。
      # 設定可能な値: 有効なリビジョン番号（正の整数）
      revision = 1
    }
  }

  #-------------------------------------------------------------
  # ログ設定
  #-------------------------------------------------------------

  # log_delivery (Optional)
  # 設定内容: コネクターのログ配信先設定を指定するブロックです。
  log_delivery {
    # worker_log_delivery (Required)
    # 設定内容: ワーカーのログ配信設定を指定するブロックです。
    worker_log_delivery {
      # cloudwatch_logs (Optional)
      # 設定内容: CloudWatch Logs へのログ配信設定を指定するブロックです。
      cloudwatch_logs {
        # enabled (Required)
        # 設定内容: CloudWatch Logs へのログ配信を有効化するかを指定します。
        # 設定可能な値: true, false
        enabled = true

        # log_group (Optional)
        # 設定内容: ログの配信先 CloudWatch Logs グループ名を指定します。
        # 設定可能な値: 有効な CloudWatch Logs グループ名
        # 省略時: enabled = true の場合は指定が必要
        log_group = "/aws/mskconnect/example-connector"
      }

      # firehose (Optional)
      # 設定内容: Amazon Kinesis Data Firehose へのログ配信設定を指定するブロックです。
      firehose {
        # enabled (Required)
        # 設定内容: Kinesis Data Firehose へのログ配信を有効化するかを指定します。
        # 設定可能な値: true, false
        enabled = false

        # delivery_stream (Optional)
        # 設定内容: ログの配信先 Kinesis Data Firehose 配信ストリーム名を指定します。
        # 設定可能な値: 有効な Kinesis Data Firehose 配信ストリーム名
        # 省略時: enabled = true の場合は指定が必要
        delivery_stream = null
      }

      # s3 (Optional)
      # 設定内容: Amazon S3 へのログ配信設定を指定するブロックです。
      s3 {
        # enabled (Required)
        # 設定内容: S3 へのログ配信を有効化するかを指定します。
        # 設定可能な値: true, false
        enabled = false

        # bucket (Optional)
        # 設定内容: ログの配信先 S3 バケット名を指定します。
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
  # ワーカー設定
  #-------------------------------------------------------------

  # worker_configuration (Optional)
  # 設定内容: コネクターワーカーのカスタム設定を指定するブロックです。
  # 省略時: MSK Connect のデフォルトワーカー設定を使用
  worker_configuration {
    # arn (Required)
    # 設定内容: 使用するワーカー設定の ARN を指定します。
    # 設定可能な値: 有効な MSK Connect ワーカー設定の ARN
    arn = "arn:aws:kafkaconnect:ap-northeast-1:123456789012:worker-configuration/example-worker-config/abcd1234-1234-1234-1234-abcdef123456-1"

    # revision (Required)
    # 設定内容: 使用するワーカー設定のリビジョン番号を指定します。
    # 設定可能な値: 有効なリビジョン番号（正の整数）
    revision = 1
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 注意: MSK Connect コネクターの作成・更新・削除には数分〜数十分かかる場合があります
  timeouts {
    # create (Optional)
    # 設定内容: コネクターの作成操作のタイムアウト時間を指定します。
    # 設定可能な値: Go の時間パース形式（例: "60m", "1h"）
    # 省略時: Terraform のデフォルトタイムアウトを使用
    create = "60m"

    # update (Optional)
    # 設定内容: コネクターの更新操作のタイムアウト時間を指定します。
    # 設定可能な値: Go の時間パース形式（例: "60m", "1h"）
    # 省略時: Terraform のデフォルトタイムアウトを使用
    update = "60m"

    # delete (Optional)
    # 設定内容: コネクターの削除操作のタイムアウト時間を指定します。
    # 設定可能な値: Go の時間パース形式（例: "60m", "1h"）
    # 省略時: Terraform のデフォルトタイムアウトを使用
    delete = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn / id: MSK Connect コネクターの ARN
# - version: コネクターの現在のバージョン（更新時に使用）
# - tags_all: プロバイダーの default_tags から継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
