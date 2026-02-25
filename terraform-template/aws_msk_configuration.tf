#---------------------------------------------------------------
# Amazon MSK Configuration
#---------------------------------------------------------------
#
# Amazon Managed Streaming for Apache Kafka (MSK) のカスタム設定を
# プロビジョニングするリソースです。
# MSK設定はApache Kafkaブローカーの動作を制御するserver.propertiesの
# プロパティセットを定義し、MSKクラスターに関連付けることができます。
#
# AWS公式ドキュメント:
#   - Amazon MSK設定: https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration.html
#   - カスタムMSK設定: https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration-properties.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_msk_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: MSK設定の名前を指定します。
  # 設定可能な値: 文字列（英数字、ハイフン、アンダースコアを使用可能）
  name = "example-msk-configuration"

  # description (Optional)
  # 設定内容: MSK設定の説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なしで設定が作成されます。
  description = "Example MSK configuration"

  #-------------------------------------------------------------
  # Kafkaバージョン設定
  #-------------------------------------------------------------

  # kafka_versions (Optional)
  # 設定内容: この設定を使用できるApache Kafkaバージョンのリストを指定します。
  # 設定可能な値: Kafkaバージョン文字列のセット（例: "2.1.0", "2.6.0", "3.4.0"）
  # 省略時: すべてのKafkaバージョンで使用可能となります。
  # 参考: https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration.html
  kafka_versions = ["2.6.0", "3.4.0"]

  #-------------------------------------------------------------
  # サーバープロパティ設定
  #-------------------------------------------------------------

  # server_properties (Required)
  # 設定内容: server.propertiesファイルの内容を指定します。
  #           Apache Kafkaブローカーの動作を制御するプロパティを定義します。
  # 設定可能な値: Apache Kafkaのserver.propertiesフォーマットの文字列
  #   代表的な設定可能プロパティ:
  #   - auto.create.topics.enable: トピックの自動作成を有効化（true/false）
  #   - delete.topic.enable: トピックの削除を有効化（true/false）
  #   - log.retention.hours: ログの保持時間（時間単位）
  #   - num.partitions: デフォルトのパーティション数
  #   - default.replication.factor: デフォルトのレプリケーション係数
  #   - min.insync.replicas: 書き込み成功と見なすための最小同期レプリカ数
  #   - compression.type: 圧縮タイプ（none, gzip, snappy, lz4, zstd）
  #   - unclean.leader.election.enable: ISRでないレプリカのリーダー選出を許可（true/false）
  # 参考: https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration-properties.html
  server_properties = <<-PROPERTIES
auto.create.topics.enable = true
delete.topic.enable = true
log.retention.hours = 168
num.partitions = 1
default.replication.factor = 3
min.insync.replicas = 2
PROPERTIES

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: MSK設定のAmazon Resource Name (ARN)
#
# - latest_revision: 設定の最新リビジョン番号。
#                    設定を更新するたびにリビジョン番号がインクリメントされます。
#---------------------------------------------------------------
