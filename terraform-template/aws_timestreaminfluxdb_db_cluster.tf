#---------------------------------------------------------------
# Amazon Timestream for InfluxDB Cluster
#---------------------------------------------------------------
#
# Amazon Timestream for InfluxDBのデータベースクラスターをプロビジョニングするリソースです。
# InfluxDBはオープンソースの時系列データベースで、Timestreamと統合されることで
# マネージド環境で運用できます。InfluxDB V2とV3の両方をサポートします。
#
# AWS公式ドキュメント:
#   - Timestream for InfluxDB クラスター作成: https://docs.aws.amazon.com/timestream/latest/developerguide/creating-a-cluster.html
#   - Timestream for InfluxDB インスタンス設定: https://docs.aws.amazon.com/timestream/latest/developerguide/configuring-a-influxdb-3-instance.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/timestreaminfluxdb_db_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_timestreaminfluxdb_db_cluster" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: クラスターの一意な名前を指定します。この名前はエンドポイントのプレフィックスにも含まれます。
  # 設定可能な値: 文字で始まり、連続するハイフン（-）を含まず、ハイフンで終わらない文字列
  # 注意: クラスター名は顧客ごと、リージョンごとに一意である必要があります
  # 参考: https://docs.aws.amazon.com/timestream/latest/developerguide/creating-a-cluster.html
  name = "example-db-cluster"

  # db_instance_type (Required)
  # 設定内容: InfluxDBを実行するDB インスタンスタイプを指定します。
  # 設定可能な値:
  #   - "db.influx.medium": 小規模ワークロード向け
  #   - "db.influx.large": 中規模ワークロード向け
  #   - "db.influx.xlarge": 大規模ワークロード向け
  #   - "db.influx.2xlarge": より大規模なワークロード向け
  #   - "db.influx.4xlarge": 高負荷ワークロード向け
  #   - "db.influx.8xlarge": 非常に高負荷なワークロード向け
  #   - "db.influx.12xlarge": 最大規模ワークロード向け
  #   - "db.influx.16xlarge": 最大規模ワークロード向け
  # 注意: この引数は更新可能（インプレースアップデート）
  # 参考: https://docs.aws.amazon.com/timestream/latest/developerguide/configuring-a-influxdb-3-instance.html
  db_instance_type = "db.influx.medium"

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # vpc_subnet_ids (Required)
  # 設定内容: クラスターに関連付けるVPCサブネットIDのリストを指定します。
  # 設定可能な値: 有効なVPCサブネットIDのセット
  # 注意: Multi-AZ スタンバイでデプロイする場合は、異なるアベイラビリティーゾーンに
  #       少なくとも2つのVPCサブネットIDを提供する必要があります
  # 参考: https://docs.aws.amazon.com/timestream/latest/developerguide/configuring-a-influxdb-3-instance.html
  vpc_subnet_ids = ["subnet-12345678", "subnet-87654321"]

  # vpc_security_group_ids (Required)
  # 設定内容: クラスターに関連付けるVPCセキュリティグループIDのリストを指定します。
  # 設定可能な値: 有効なVPCセキュリティグループIDのセット
  # 参考: https://docs.aws.amazon.com/timestream/latest/developerguide/configuring-a-influxdb-3-instance.html
  vpc_security_group_ids = ["sg-12345678"]

  # network_type (Optional)
  # 設定内容: クラスターのネットワークタイプを指定します。
  # 設定可能な値:
  #   - "IPV4": IPv4プロトコルのみで通信
  #   - "DUAL": IPv4とIPv6の両方のプロトコルで通信
  # 省略時: デフォルト値が適用されます
  # 参考: https://docs.aws.amazon.com/timestream/latest/developerguide/configuring-a-influxdb-3-instance.html
  network_type = null

  # publicly_accessible (Optional)
  # 設定内容: パブリックIPでクラスターにアクセスできるようにするかを指定します。
  # 設定可能な値:
  #   - true: パブリックアクセスを有効化
  #   - false (デフォルト): パブリックアクセスを無効化
  # 注意: パブリックアクセスを有効にするには、VPC、サブネット、インターネットゲートウェイ、
  #       ルートテーブルなどの他のリソースも必要です
  # 参考: https://docs.aws.amazon.com/timestream/latest/developerguide/creating-a-cluster.html
  publicly_accessible = false

  # port (Optional)
  # 設定内容: InfluxDBが接続を受け付けるポート番号を指定します。
  # 設定可能な値: 1024-65535の範囲（2375-2376、7788-7799、8090、51678-51680は使用不可）
  # 省略時: 8086（デフォルト）
  # 注意: この引数は更新可能（インプレースアップデート）
  # 参考: https://docs.aws.amazon.com/timestream/latest/developerguide/configuring-a-influxdb-3-instance.html
  port = null

  #-------------------------------------------------------------
  # ストレージ設定
  #-------------------------------------------------------------

  # allocated_storage (Optional)
  # 設定内容: DBストレージタイプに割り当てるストレージ容量をGiB（ギビバイト）で指定します。
  # 設定可能な値:
  #   - 最小値: 20 GiB（db_storage_typeが"InfluxIOIncludedT1"の場合）
  #   - 最小値: 400 GiB（db_storage_typeが"InfluxIOIncludedT2"または"InfluxIOIncludedT3"の場合）
  #   - 最大値: 16384 GiB
  # 注意: InfluxDB V3クラスター（InfluxDB V3 dbパラメータグループ使用時）では
  #       このフィールドは禁止されています
  # 参考: https://docs.aws.amazon.com/timestream/latest/developerguide/configuring-a-influxdb-3-instance.html
  allocated_storage = null

  # db_storage_type (Optional)
  # 設定内容: InfluxDBデータの読み書きに使用するストレージタイプを指定します。
  # 設定可能な値:
  #   - "InfluxIOIncludedT1" (デフォルト): Influx IO Included 3000 IOPS
  #   - "InfluxIOIncludedT2": Influx IO Included 12000 IOPS（allocated_storage最小値400 GiB）
  #   - "InfluxIOIncludedT3": Influx IO Included 16000 IOPS（allocated_storage最小値400 GiB）
  # 省略時: "InfluxIOIncludedT1"
  # 注意: ワークロード要件に応じて、3つの異なるプロビジョニングIOPSから選択可能
  # 参考: https://docs.aws.amazon.com/timestream/latest/developerguide/configuring-a-influxdb-3-instance.html
  db_storage_type = null

  #-------------------------------------------------------------
  # クラスター設定
  #-------------------------------------------------------------

  # deployment_type (Optional)
  # 設定内容: 作成するクラスターのタイプを指定します。
  # 設定可能な値:
  #   - "MULTI_NODE_READ_REPLICAS": マルチノード読み取りレプリカ構成
  # 省略時: InfluxDB V2クラスターでは"MULTI_NODE_READ_REPLICAS"がデフォルト
  # 注意: InfluxDB V3クラスター（InfluxDB V3 dbパラメータグループ使用時）では
  #       このフィールドは禁止されています
  # 参考: https://docs.aws.amazon.com/timestream/latest/developerguide/creating-a-cluster.html
  deployment_type = null

  # failover_mode (Optional)
  # 設定内容: クラスターのプライマリノードが障害時のフェイルオーバー回復動作を指定します。
  # 設定可能な値:
  #   - "AUTOMATIC" (デフォルト): 自動フェイルオーバー
  #   - "NO_FAILOVER": フェイルオーバーなし
  # 省略時: "AUTOMATIC"
  # 注意: この引数は更新可能（インプレースアップデート）
  # 参考: https://docs.aws.amazon.com/timestream/latest/developerguide/creating-a-cluster.html
  failover_mode = null

  # db_parameter_group_identifier (Optional)
  # 設定内容: クラスターに割り当てるDBパラメータグループのIDを指定します。
  # 設定可能な値: 有効なDBパラメータグループ識別子（例: "InfluxDBV3Core"）
  # 注意: この引数は更新可能（インプレースアップデート）。ただし、既存のクラスターから
  #       db_parameter_group_identifierを削除すると、クラスターが破棄され再作成されます
  # 参考: https://docs.aws.amazon.com/timestream/latest/developerguide/configuring-a-influxdb-3-instance.html
  db_parameter_group_identifier = null

  #-------------------------------------------------------------
  # InfluxDB V2認証設定（V3では使用不可）
  #-------------------------------------------------------------

  # username (Optional)
  # 設定内容: InfluxDBで作成される初期管理ユーザーのユーザー名を指定します。
  # 設定可能な値: 文字で始まり、ハイフンで終わらず、連続するハイフンを含まない文字列
  # 注意: bucket、organization、passwordとともにinflux_auth_parameters_secret_arnで
  #       参照されるシークレットに保存されます。InfluxDB V3クラスター（InfluxDB V3 db
  #       パラメータグループ使用時）ではこのフィールドは禁止されています
  # 参考: https://docs.aws.amazon.com/timestream/latest/developerguide/creating-a-cluster.html
  username = null

  # password (Optional)
  # 設定内容: InfluxDBで作成される初期管理ユーザーのパスワードを指定します。
  # 設定可能な値: パスワード文字列（機密情報）
  # 注意: このパスワードでInfluxDB UIへのアクセスやInfluxDB CLIでの操作が可能になります。
  #       bucket、username、organizationとともにinflux_auth_parameters_secret_arnで
  #       参照されるシークレットに保存されます。InfluxDB V3クラスター（InfluxDB V3 db
  #       パラメータグループ使用時）ではAWS APIが拒否するため禁止されています
  # 参考: https://docs.aws.amazon.com/timestream/latest/developerguide/creating-a-cluster.html
  password = null

  # organization (Optional)
  # 設定内容: InfluxDBの初期管理ユーザー用の初期組織名を指定します。
  # 設定可能な値: 組織名文字列
  # 注意: InfluxDB組織はユーザーグループのワークスペースです。bucket、username、passwordと
  #       ともにinflux_auth_parameters_secret_arnで参照されるシークレットに保存されます。
  #       InfluxDB V3クラスター（InfluxDB V3 dbパラメータグループ使用時）では
  #       このフィールドは禁止されています
  # 参考: https://docs.aws.amazon.com/timestream/latest/developerguide/creating-a-cluster.html
  organization = null

  # bucket (Optional)
  # 設定内容: 初期InfluxDBバケットの名前を指定します。
  # 設定可能な値: バケット名文字列
  # 関連機能: InfluxDB バケット
  #   すべてのInfluxDBデータはバケットに保存されます。バケットはデータベースと
  #   保持期間（各データポイントが保持される期間）の概念を組み合わせたもので、
  #   組織に属します。
  # 注意: organization、username、passwordとともにinflux_auth_parameters_secret_arnで
  #       参照されるシークレットに保存されます。InfluxDB V3クラスター（InfluxDB V3 db
  #       パラメータグループ使用時）ではこのフィールドは禁止されています
  # 参考: https://docs.aws.amazon.com/timestream/latest/developerguide/creating-a-cluster.html
  bucket = null

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
  tags = {
    Name        = "example-db-cluster"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # ログ配信設定
  #-------------------------------------------------------------

  # log_delivery_configuration (Optional)
  # 設定内容: InfluxDBエンジンログを指定したS3バケットに送信する設定を指定します。
  # 注意: この引数は更新可能（インプレースアップデート）
  # 参考: https://docs.aws.amazon.com/timestream/latest/developerguide/creating-a-cluster.html
  log_delivery_configuration {
    s3_configuration {
      # bucket_name (Required)
      # 設定内容: ログを配信するS3バケットの名前を指定します。
      # 設定可能な値: 有効なS3バケット名
      bucket_name = "example-s3-bucket"

      # enabled (Required)
      # 設定内容: S3バケットへのログ配信を有効にするかを指定します。
      # 設定可能な値:
      #   - true: ログ配信を有効化
      #   - false: ログ配信を無効化
      enabled = true
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: クラスター作成のタイムアウト時間を指定します。
    # 設定可能な値: "30s"、"2h45m"など、数値と単位サフィックスで構成される文字列
    # 注意: 有効な時間単位は "s"（秒）、"m"（分）、"h"（時間）
    create = null

    # update (Optional)
    # 設定内容: クラスター更新のタイムアウト時間を指定します。
    # 設定可能な値: "30s"、"2h45m"など、数値と単位サフィックスで構成される文字列
    # 注意: 有効な時間単位は "s"（秒）、"m"（分）、"h"（時間）
    update = null

    # delete (Optional)
    # 設定内容: クラスター削除のタイムアウト時間を指定します。
    # 設定可能な値: "30s"、"2h45m"など、数値と単位サフィックスで構成される文字列
    # 注意: Delete操作のタイムアウト設定は、destroy操作が発生する前に
    #       変更が状態に保存される場合にのみ適用されます
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Timestream for InfluxDBクラスターのAmazon Resource Name (ARN)
#
# - endpoint: InfluxDBへの接続に使用されるエンドポイント。
#             デフォルトのInfluxDBポートは8086です
#
# - engine_type: DBクラスターのデータベースエンジンタイプ
#
# - id: Timestream for InfluxDBクラスターのID
#
# - influx_auth_parameters_secret_arn: 初期InfluxDB認証パラメータを含む
#   AWS Secrets ManagerシークレットのARN。InfluxDB V2クラスターの場合、
#   シークレット値はJSON形式のキーバリューペア（organization、bucket、
#   username、password）です。InfluxDB V3クラスターの場合、シークレットには
#   InfluxDB管理トークンが含まれます
#
# - reader_endpoint: 読み取り専用操作のためのTimestream for InfluxDB
#   クラスターへの接続に使用されるエンドポイント
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
