#---------------------------------------------------------------
# AWS Timestream for InfluxDB DB Instance
#---------------------------------------------------------------
#
# Amazon Timestream for InfluxDB のDBインスタンスをプロビジョニングするリソースです。
# Timestream for InfluxDB は、InfluxDB のオープンソースAPIを使用して
# 時系列データを保存・処理できるマネージドサービスです。
#
# AWS公式ドキュメント:
#   - Timestream for InfluxDB DBインスタンスの設定: https://docs.aws.amazon.com/timestream/latest/developerguide/timestream-for-influx-configuring.html
#   - Timestream for InfluxDB DBインスタンスへの接続: https://docs.aws.amazon.com/timestream/latest/developerguide/timestream-for-influx-db-connecting.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/timestreaminfluxdb_db_instance
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_timestreaminfluxdb_db_instance" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: DBインスタンスを一意に識別する名前を指定します。
  # 設定可能な値: 文字列。先頭は英字で始まり、連続するハイフンやハイフンで終わることはできません。
  # 注意: この名前はエンドポイントのプレフィックスとしても使用されます。
  #       顧客・リージョンごとに一意である必要があります。
  name = "example-db-instance"

  # allocated_storage (Required)
  # 設定内容: DBストレージタイプに割り当てるストレージ量をGiB単位で指定します。
  # 設定可能な値: 20〜16384の数値
  # 注意: db_storage_typeの値により最小値が異なります。
  #       InfluxIOIncludedT1: 最小20、InfluxIOIncludedT2/T3: 最小400
  #       この引数はインプレース更新が可能です。
  allocated_storage = 20

  # db_instance_type (Required)
  # 設定内容: InfluxDBを実行するDBインスタンスタイプを指定します。
  # 設定可能な値:
  #   - "db.influx.medium"
  #   - "db.influx.large"
  #   - "db.influx.xlarge"
  #   - "db.influx.2xlarge"
  #   - "db.influx.4xlarge"
  #   - "db.influx.8xlarge"
  #   - "db.influx.12xlarge"
  #   - "db.influx.16xlarge"
  # 注意: この引数はインプレース更新が可能です。
  db_instance_type = "db.influx.medium"

  #-------------------------------------------------------------
  # InfluxDB初期設定
  #-------------------------------------------------------------

  # organization (Required, Forces new resource)
  # 設定内容: InfluxDBの初期管理ユーザーの初期組織名を指定します。
  # 設定可能な値: 文字列
  # 注意: bucket、username、passwordと共にAWS Secrets Managerのシークレットに保存されます。
  organization = "my-organization"

  # bucket (Required, Forces new resource)
  # 設定内容: 初期InfluxDBバケットの名前を指定します。
  # 設定可能な値: 文字列
  # 注意: InfluxDBのバケットはデータベースと保持期間の概念を組み合わせたものです。
  #       organization、username、passwordと共にAWS Secrets Managerのシークレットに保存されます。
  bucket = "example-bucket"

  # username (Required, Forces new resource)
  # 設定内容: InfluxDBの初期管理ユーザーのユーザー名を指定します。
  # 設定可能な値: 文字列。先頭は英字で始まり、ハイフンで終わったり連続するハイフンを含めることはできません。
  # 注意: InfluxDB UIへのアクセスやInfluxDB CLIでのオペレータートークン作成に使用されます。
  #       bucket、organization、passwordと共にAWS Secrets Managerのシークレットに保存されます。
  username = "admin"

  # password (Required, Forces new resource, Sensitive)
  # 設定内容: InfluxDBの初期管理ユーザーのパスワードを指定します。
  # 設定可能な値: 文字列
  # 注意: InfluxDB UIへのアクセスやInfluxDB CLIでのオペレータートークン作成に使用されます。
  #       bucket、username、organizationと共にAWS Secrets Managerのシークレットに保存されます。
  password = "example-password"

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # vpc_subnet_ids (Required, Forces new resource)
  # 設定内容: DBインスタンスに関連付けるVPCサブネットIDのリストを指定します。
  # 設定可能な値: VPCサブネットIDのセット
  # 注意: Multi-AZスタンバイでデプロイする場合は、異なるアベイラビリティゾーンの
  #       少なくとも2つのVPCサブネットIDを指定してください。
  vpc_subnet_ids = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-yyyyyyyyyyyyyyyyy"]

  # vpc_security_group_ids (Required, Forces new resource)
  # 設定内容: DBインスタンスに関連付けるVPCセキュリティグループIDのリストを指定します。
  # 設定可能な値: VPCセキュリティグループIDのセット
  vpc_security_group_ids = ["sg-xxxxxxxxxxxxxxxxx"]

  # publicly_accessible (Optional)
  # 設定内容: DBインスタンスにパブリックIPを設定してアクセスを可能にするかを指定します。
  # 設定可能な値:
  #   - true: パブリックアクセスを有効化
  #   - false (デフォルト): パブリックアクセスを無効化
  # 注意: パブリックアクセスを有効にするには、VPC、サブネット、インターネットゲートウェイ、
  #       ルートテーブルなどの追加リソースも必要です。
  publicly_accessible = false

  # port (Optional)
  # 設定内容: インスタンスが接続を受け付けるポート番号を指定します。
  # 設定可能な値: 1024〜65535の整数
  # 省略時: 8086
  # 注意: 2375-2376、7788-7799、8090、51678-51680は使用不可。
  #       この引数はインプレース更新が可能です。
  port = 8086

  # network_type (Optional)
  # 設定内容: インスタンスのネットワークタイプを指定します。
  # 設定可能な値:
  #   - "IPV4": IPv4プロトコルのみで通信
  #   - "DUAL": IPv4とIPv6の両方のプロトコルで通信
  # 省略時: プロバイダーのデフォルト値
  network_type = null

  #-------------------------------------------------------------
  # ストレージ設定
  #-------------------------------------------------------------

  # db_storage_type (Optional)
  # 設定内容: InfluxDBデータの読み書きに使用するDBストレージタイプを指定します。
  # 設定可能な値:
  #   - "InfluxIOIncludedT1" (デフォルト): Influx IO Included 3000 IOPS
  #   - "InfluxIOIncludedT2": Influx IO Included 12000 IOPS (allocated_storage最小400)
  #   - "InfluxIOIncludedT3": Influx IO Included 16000 IOPS (allocated_storage最小400)
  # 注意: この引数はインプレース更新が可能です。シングルインスタンスの場合、
  #       更新後6時間経過しないと再度更新できません。
  db_storage_type = "InfluxIOIncludedT1"

  #-------------------------------------------------------------
  # 可用性設定
  #-------------------------------------------------------------

  # deployment_type (Optional)
  # 設定内容: DBインスタンスをスタンドアロンで展開するか、Multi-AZスタンバイで展開するかを指定します。
  # 設定可能な値:
  #   - "SINGLE_AZ" (デフォルト): シングルAZでの展開
  #   - "WITH_MULTIAZ_STANDBY": Multi-AZスタンバイでの高可用性展開
  # 注意: この引数はインプレース更新が可能です。
  #       Multi-AZの場合はvpc_subnet_idsに異なるAZの2つ以上のサブネットが必要です。
  deployment_type = "SINGLE_AZ"

  #-------------------------------------------------------------
  # パラメータグループ設定
  #-------------------------------------------------------------

  # db_parameter_group_identifier (Optional)
  # 設定内容: DBインスタンスに割り当てるDBパラメータグループのIDを指定します。
  # 設定可能な値: 有効なDBパラメータグループID
  # 注意: この引数はインプレース更新が可能です。既存のインスタンスに追加または変更した場合は
  #       インプレース更新されますが、削除した場合はインスタンスが破棄・再作成されます。
  # 参考: https://docs.aws.amazon.com/timestream/latest/developerguide/timestream-for-influx-db-connecting.html
  db_parameter_group_identifier = null

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
  # ログ配信設定
  #-------------------------------------------------------------

  # log_delivery_configuration (Optional)
  # 設定内容: InfluxDBエンジンログを指定したS3バケットに送信するための設定を指定します。
  # 注意: この引数はインプレース更新が可能です。
  log_delivery_configuration {
    # s3_configuration (Required)
    # 設定内容: S3バケットへのログ配信の設定を指定します。
    s3_configuration {
      # bucket_name (Required)
      # 設定内容: ログを配信するS3バケットの名前を指定します。
      # 設定可能な値: 有効なS3バケット名
      # 注意: S3バケットにはtimestream-influxdb.amazonaws.comからのs3:PutObjectを
      #       許可するバケットポリシーが必要です。
      bucket_name = "example-log-bucket"

      # enabled (Required)
      # 設定内容: S3バケットへのログ配信を有効にするかを指定します。
      # 設定可能な値:
      #   - true: ログ配信を有効化
      #   - false: ログ配信を無効化
      enabled = true
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-db-instance"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "30s", "2h45m"）
    # 有効な時間単位: "s"（秒）、"m"（分）、"h"（時間）
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "30s", "2h45m"）
    # 有効な時間単位: "s"（秒）、"m"（分）、"h"（時間）
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "30s", "2h45m"）
    # 有効な時間単位: "s"（秒）、"m"（分）、"h"（時間）
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Timestream for InfluxDBインスタンスのARN
#
# - id: Timestream for InfluxDBインスタンスのID
#
# - availability_zone: DBインスタンスが配置されているアベイラビリティゾーン
#
# - endpoint: InfluxDBへの接続に使用するエンドポイント。デフォルトのInfluxDBポートは8086
#
# - influx_auth_parameters_secret_arn: 初期InfluxDB認証パラメータを含む
#     AWS Secrets ManagerシークレットのARN。シークレット値はJSON形式の
#     キーバリューペアで、organization、bucket、username、passwordを保持
#
# - secondary_availability_zone: Multi-AZスタンバイインスタンスでデプロイした場合の
#     スタンバイインスタンスが配置されているアベイラビリティゾーン
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
