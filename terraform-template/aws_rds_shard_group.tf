#---------------------------------------------------------------
# Amazon Aurora Limitless Database DB Shard Group
#---------------------------------------------------------------
#
# Amazon Aurora Limitless DatabaseのDBシャードグループを管理するリソースです。
# Aurora Limitless Databaseは、大規模なワークロードに対応するため、
# 単一のデータベースのスケール制限を超えて水平方向にスケールできる
# 分散データベースソリューションです。DBシャードグループは、
# データとトランザクションを複数のシャードに分散し、
# Aurora Capacity Units (ACU)で定義された計算容量を提供します。
#
# AWS公式ドキュメント:
#   - Aurora Limitless Database概要: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-limitless.html
#   - DBシャードグループ作成: https://docs.aws.amazon.com/cli/latest/reference/rds/create-shard-group.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_shard_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rds_shard_group" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # db_shard_group_identifier (Required)
  # 設定内容: DBシャードグループの名前を指定します。
  # 設定可能な値: 1文字以上の文字列
  # 注意: リソース作成後の変更はできません（Forces new resource）
  # 命名規則: 英数字とハイフンのみ使用可能、最初の文字は英字である必要があります
  db_shard_group_identifier = "example-shard-group"

  # db_cluster_identifier (Required)
  # 設定内容: プライマリDBクラスターの名前を指定します。
  # 設定可能な値: 既存のAurora Limitless DatabaseクラスターのID
  # 注意: Aurora Limitless Databaseをサポートするクラスター
  #       （engine_version: "16.6-limitless"、cluster_scalability_type: "limitless"）
  #       を指定する必要があります
  # 関連機能: Aurora Limitless Databaseクラスター
  #   - engine: "aurora-postgresql"
  #   - engine_version: "16.6-limitless"
  #   - cluster_scalability_type: "limitless"
  db_cluster_identifier = aws_rds_cluster.example.id

  # max_acu (Required)
  # 設定内容: DBシャードグループの最大容量をAurora Capacity Units (ACU)で指定します。
  # 設定可能な値: 正の数値（例: 1200）
  # 注意: ACUは、CPUとメモリの組み合わせを表す仮想単位です。
  #       ワークロードの要件に応じて適切な値を設定してください。
  # 関連機能: Aurora Serverless v2スケーリング
  #   - 1 ACU = 2 GiB RAM、対応するCPUとネットワーキング
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.how-it-works.html
  max_acu = 1200

  #-------------------------------------------------------------
  # オプションパラメータ - 容量設定
  #-------------------------------------------------------------

  # min_acu (Optional)
  # 設定内容: DBシャードグループの最小容量をAurora Capacity Units (ACU)で指定します。
  # 設定可能な値: 正の数値
  # 省略時: AWSによって自動的に決定されます
  # 注意: min_acuはmax_acu以下である必要があります
  # 関連機能: オートスケーリング
  #   シャードグループは、ワークロードに応じてmin_acuとmax_acuの間で
  #   自動的にスケールします
  min_acu = 100

  #-------------------------------------------------------------
  # オプションパラメータ - 冗長性設定
  #-------------------------------------------------------------

  # compute_redundancy (Optional)
  # 設定内容: スタンバイDBシャードグループを作成するかどうかを指定します。
  # 設定可能な値:
  #   - 0: スタンバイDBシャードグループなしでDBシャードグループを作成（デフォルト）
  #   - 1: 異なるアベイラビリティゾーン(AZ)にスタンバイDBシャードグループを1つ作成
  #   - 2: 2つの異なるAZにスタンバイDBシャードグループを2つ作成
  # 省略時: 0（スタンバイなし）
  # 関連機能: 高可用性とディザスタリカバリ
  #   複数のAZにスタンバイを配置することで、可用性と耐障害性が向上します
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.AuroraHighAvailability.html
  compute_redundancy = 1

  #-------------------------------------------------------------
  # オプションパラメータ - ネットワーク設定
  #-------------------------------------------------------------

  # publicly_accessible (Optional)
  # 設定内容: DBシャードグループがパブリックにアクセス可能かどうかを指定します。
  # 設定可能な値:
  #   - true: パブリックIPアドレスを割り当て、インターネットからアクセス可能にします
  #   - false: プライベートIPアドレスのみを使用し、VPC内からのみアクセス可能にします
  # 省略時: AWSによって自動的に決定されます（通常はfalse）
  # セキュリティ推奨事項: 本番環境ではfalseに設定し、VPC内からのみアクセスを許可することを推奨します
  publicly_accessible = false

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
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-shard-group"
    Environment = "production"
    Application = "limitless-database"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成、更新、削除操作のタイムアウトを指定します。
  # 注意: DBシャードグループの作成や削除には時間がかかる場合があります
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "30s"、"2h45m"などの期間文字列
    # 有効な時間単位: "s"（秒）、"m"（分）、"h"（時間）
    # 省略時: デフォルトのタイムアウト値が使用されます
    create = "60m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "30s"、"2h45m"などの期間文字列
    # 有効な時間単位: "s"（秒）、"m"（分）、"h"（時間）
    # 省略時: デフォルトのタイムアウト値が使用されます
    update = "60m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "30s"、"2h45m"などの期間文字列
    # 有効な時間単位: "s"（秒）、"m"（分）、"h"（時間）
    # 省略時: デフォルトのタイムアウト値が使用されます
    # 注意: タイムアウトの設定は、変更がstateに保存された後に
    #       destroy操作が発生する場合にのみ適用されます
    delete = "60m"
  }
}

#---------------------------------------------------------------
# 関連リソース例: Aurora Limitless Databaseクラスター
#---------------------------------------------------------------
# DBシャードグループを使用するには、まずAurora Limitless Database
# クラスターを作成する必要があります。以下は設定例です。

# resource "aws_rds_cluster" "example" {
#   cluster_identifier                    = "example-limitless-cluster"
#   engine                                = "aurora-postgresql"
#   engine_version                        = "16.6-limitless"
#   engine_mode                           = ""
#   storage_type                          = "aurora-iopt1"
#   cluster_scalability_type              = "limitless"
#   master_username                       = "admin"
#   master_password                       = "must_be_eight_characters_minimum"
#   performance_insights_enabled          = true
#   performance_insights_retention_period = 31
#   enabled_cloudwatch_logs_exports       = ["postgresql"]
#   monitoring_interval                   = 5
#   monitoring_role_arn                   = aws_iam_role.example.arn
#
#   tags = {
#     Name        = "example-limitless-cluster"
#     Environment = "production"
#   }
# }

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: シャードグループのAmazon Resource Name (ARN)
#
# - db_shard_group_resource_id: DBシャードグループのAWSリージョン固有の
#                                不変識別子
#
# - endpoint: DBシャードグループの接続エンドポイント
#             アプリケーションからこのエンドポイントを使用して
#             シャードグループに接続します
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# 1. 容量設定のベストプラクティス:
#    - 予測可能なワークロードの場合、min_acuとmax_acuを近い値に設定
#    - 変動の激しいワークロードの場合、広い範囲を設定して自動スケーリングを活用
#    - コスト最適化のため、ワークロードの最小要件に基づいてmin_acuを設定
#
# 2. 高可用性の考慮事項:
#---------------------------------------------------------------
