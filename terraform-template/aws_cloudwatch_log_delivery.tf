#---------------------------------------------------------------
# AWS CloudWatch Logs Delivery
#---------------------------------------------------------------
#
# Amazon CloudWatch LogsのDelivery（配信）をプロビジョニングするリソースです。
# Deliveryは、Delivery Source（配信元）とDelivery Destination（配信先）を
# 接続する論理的なオブジェクトです。
#
# 配信先として以下をサポート:
#   - CloudWatch Logs（ロググループ）
#   - Amazon S3（バケット）
#   - Amazon Data Firehose（配信ストリーム）
#   - AWS X-Ray
#
# AWS公式ドキュメント:
#   - CloudWatch Logs Delivery: https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_CreateDelivery.html
#   - ログ配信の概要: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AWS-logs-and-resource-policy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_delivery
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_log_delivery" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # delivery_source_name (Required)
  # 設定内容: このDeliveryに使用するDelivery Sourceの名前を指定します。
  # 設定可能な値: 1-60文字の文字列（英数字、ハイフン、アンダースコア）
  # 関連機能: CloudWatch Logs Delivery Source
  #   ログを送信するAWSリソースを表す論理的なオブジェクト。
  #   事前にaws_cloudwatch_log_delivery_sourceで作成が必要です。
  #   - https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_PutDeliverySource.html
  delivery_source_name = aws_cloudwatch_log_delivery_source.example.name

  # delivery_destination_arn (Required)
  # 設定内容: このDeliveryに使用するDelivery DestinationのARNを指定します。
  # 設定可能な値: 有効なDelivery DestinationのARN
  # 関連機能: CloudWatch Logs Delivery Destination
  #   ログを送信する宛先を表す論理的なオブジェクト。
  #   CloudWatch Logs、S3、Firehose、X-Rayを配信先として設定可能。
  #   事前にaws_cloudwatch_log_delivery_destinationで作成が必要です。
  #   - https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_PutDeliveryDestination.html
  delivery_destination_arn = aws_cloudwatch_log_delivery_destination.example.arn

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
  # レコードフィールド設定
  #-------------------------------------------------------------

  # field_delimiter (Optional)
  # 設定内容: 最終出力フォーマットがPlain、W3C、またはRaw形式の場合に
  #          レコードフィールド間で使用するフィールド区切り文字を指定します。
  # 設定可能な値: 0-5文字の文字列（例: ",", "\t", " "）
  # 用途: ログレコードの各フィールドを区切る文字を指定
  field_delimiter = ","

  # record_fields (Optional)
  # 設定内容: 配信先に配信されるレコードフィールドのリストを順序付きで指定します。
  # 設定可能な値: 文字列のリスト（最大128項目、各項目1-64文字）
  # 注意: ログソースに必須フィールドがある場合、このリストに含める必要があります。
  # 例: ["event_timestamp", "event", "account_id", "region"]
  # 関連機能: DescribeConfigurationTemplates APIで使用可能なフィールドを確認可能
  #   - https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_DescribeConfigurationTemplates.html
  record_fields = ["event_timestamp", "event"]

  #-------------------------------------------------------------
  # S3配信設定
  #-------------------------------------------------------------

  # s3_delivery_configuration (Optional)
  # 設定内容: 配信先がS3バケットの場合にのみ適用される配信設定を指定します。
  # 注意: 配信先がS3以外の場合、この設定は無視されます。
  # 関連機能: S3 Delivery Configuration
  #   S3バケットへのログ配信時のパス構造をカスタマイズ可能。
  #   - https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_S3DeliveryConfiguration.html
  s3_delivery_configuration = [
    {
      # enable_hive_compatible_path (Optional)
      # 設定内容: Apache Hiveとの統合を可能にするプレフィックス構造を使用するかを指定します。
      # 設定可能な値:
      #   - true: Hive互換のパス構造を使用（year=YYYY/month=MM/day=DD形式）
      #   - false: 標準のパス構造を使用
      # 用途: Athena、EMR、Glueなどのビッグデータ分析ツールとの統合を容易にする
      enable_hive_compatible_path = false

      # suffix_path (Optional)
      # 設定内容: S3オブジェクトプレフィックスに静的または変数セクションを含めるための
      #          サフィックスパスを指定します。
      # 設定可能な値: 1-256文字の文字列
      # 使用可能な変数: ログソースによって異なります。
      #   DescribeConfigurationTemplates APIのallowedSuffixPathFieldsで確認可能。
      # 例: "{yyyy}/{MM}/{dd}/{HH}" など
      suffix_path = null
    }
  ]

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（最大50個）
  #   - キー: 1-128文字
  #   - 値: 最大256文字
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "example-delivery"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: DeliveryのAmazon Resource Name (ARN)
#
# - id: このDeliveryを識別する一意のID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 関連リソースとの組み合わせ
#---------------------------------------------------------------
# Deliveryを作成するには、事前にDelivery SourceとDelivery Destinationの
# 作成が必要です。
#
# # Delivery Source (配信元)
# resource "aws_cloudwatch_log_delivery_source" "example" {
#   name         = "example-source"
#   log_type     = "APPLICATION_LOGS"
#   resource_arn = aws_vpc.example.arn
# }
#
# # Delivery Destination (配信先 - CloudWatch Logsの場合)
# resource "aws_cloudwatch_log_delivery_destination" "example" {
#   name = "example-destination"
#   delivery_destination_configuration {
#     destination_resource_arn = aws_cloudwatch_log_group.example.arn
#   }
# }
#
# # Delivery Destination (配信先 - S3の場合)
# resource "aws_cloudwatch_log_delivery_destination" "s3" {
#   name = "s3-destination"
#   delivery_destination_configuration {
#     destination_resource_arn = aws_s3_bucket.example.arn
#   }
# }
#---------------------------------------------------------------
