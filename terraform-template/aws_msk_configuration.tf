#---------------------------------------------------------------
# AWS MSK Configuration
#---------------------------------------------------------------
#
# Amazon Managed Streaming for Apache Kafka (MSK) のカスタム設定を
# 作成・管理するリソース。MSK設定では、Apache Kafkaの設定プロパティを
# カスタマイズでき、クラスター作成時または更新時に適用できる。
#
# AWS公式ドキュメント:
#   - MSK設定の概要: https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration.html
#   - カスタム設定プロパティ: https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration-properties.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_msk_configuration" "this" {
  #---------------------------------------------
  # Required Arguments
  #---------------------------------------------

  # name (Required, string)
  # MSK設定の名前。
  # クラスター作成時や設定更新時にこの名前で参照される。
  # 一意である必要がある。
  name = "example-msk-configuration"

  # server_properties (Required, string)
  # Apache Kafkaの設定プロパティを記述する文字列。
  # server.propertiesファイルの内容に相当する。
  # 設定可能なプロパティの詳細:
  # https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration-properties.html
  #
  # 主な設定プロパティ例:
  # - auto.create.topics.enable: トピックの自動作成を有効化
  # - delete.topic.enable: トピック削除操作を有効化
  # - log.retention.hours: ログファイルの保持時間（時間単位）
  # - log.retention.bytes: ログの最大サイズ
  # - num.partitions: トピックのデフォルトパーティション数
  # - default.replication.factor: 自動作成トピックのレプリケーションファクター
  # - min.insync.replicas: 書き込み成功に必要な最小同期レプリカ数
  # - compression.type: 圧縮タイプ (gzip, snappy, lz4, zstd, uncompressed, producer)
  # - message.max.bytes: Kafkaが許可する最大レコードバッチサイズ
  server_properties = <<PROPERTIES
auto.create.topics.enable = true
delete.topic.enable = true
log.retention.hours = 168
num.partitions = 3
default.replication.factor = 3
min.insync.replicas = 2
PROPERTIES

  #---------------------------------------------
  # Optional Arguments
  #---------------------------------------------

  # description (Optional, string)
  # MSK設定の説明文。
  # 設定の目的や用途を記述するために使用する。
  description = "Example MSK configuration for production environment"

  # kafka_versions (Optional, set of strings)
  # この設定を使用できるApache Kafkaバージョンのリスト。
  # 指定しない場合、すべてのKafkaバージョンで使用可能。
  # MSKでサポートされているKafkaバージョンを指定する必要がある。
  # 例: "2.8.1", "3.3.1", "3.4.0" など
  kafka_versions = ["3.4.0"]

  # region (Optional, string)
  # このリソースを管理するAWSリージョン。
  # 指定しない場合、プロバイダー設定のリージョンが使用される。
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"
}

#---------------------------------------------------------------
# Attributes Reference (Read-only)
#---------------------------------------------------------------
#
# このリソースは以下の読み取り専用属性をエクスポートする:
#
# arn (string)
#   MSK設定のAmazon Resource Name (ARN)。
#   形式: arn:aws:kafka:{region}:{account-id}:configuration/{name}/{id}
#   クラスター作成時に設定を参照するために使用する。
#
# id (string)
#   リソースの識別子。arnと同じ値。
#
# latest_revision (number)
#   設定の最新リビジョン番号。
#   設定を更新するたびにリビジョン番号が増加する。
#   クラスターに適用する設定バージョンを指定する際に使用。
#
#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# 1. 基本的な使用例:
#
# resource "aws_msk_configuration" "example" {
#   kafka_versions = ["2.8.1"]
#   name           = "example"
#
#   server_properties = <<PROPERTIES
# auto.create.topics.enable = true
# delete.topic.enable = true
# PROPERTIES
# }
#
# 2. MSKクラスターでの使用例:
#
# resource "aws_msk_cluster" "example" {
#   cluster_name           = "example"
#   kafka_version          = "2.8.1"
#   number_of_broker_nodes = 3
#
#   configuration_info {
#     arn      = aws_msk_configuration.example.arn
#     revision = aws_msk_configuration.example.latest_revision
#   }
#
#   # ... その他の設定
# }
#
#---------------------------------------------------------------
# 注意事項
#---------------------------------------------------------------
#
# 1. 設定の更新:
#    MSK設定を更新すると新しいリビジョンが作成される。
#    既存クラスターは自動的に更新されないため、
#    クラスター側でconfiguration_infoを更新する必要がある。
#
# 2. 削除の制限:
#    クラスターで使用中の設定は削除できない。
#    先にクラスターを削除するか、別の設定に切り替える必要がある。
#
# 3. 設定プロパティの制限:
#    すべてのApache Kafka設定プロパティが変更可能なわけではない。
#    変更可能なプロパティの一覧は公式ドキュメントを参照:
#    https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration-properties.html
#
# 4. Express ブローカー:
#    Express ブローカーと Standard ブローカーで変更可能な
#    設定プロパティが異なる場合がある。
#
#---------------------------------------------------------------
