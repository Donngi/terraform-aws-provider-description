#-------
# CloudWatch Logs配信設定
#-------
# CloudWatch Logsの配信を作成・管理するリソース
# 配信は配信ソース（ログを送信するAWSリソース）と配信先（S3、Firehose、CloudWatch Logs、X-Rayなど）を接続する
# 単一の配信ソースから複数の配信先への配信、または複数の配信ソースから単一の配信先への配信が可能
#
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudwatch_log_delivery
# Generated: 2026-02-13
#
# NOTE: 配信を作成する前に、配信ソース（PutDeliverySource）と配信先（PutDeliveryDestination）を事前に作成する必要があります。
#       クロスアカウント配信の場合、配信先アカウントでPutDeliveryDestinationPolicyを使用してIAMポリシーを割り当てる必要があります。
#
# ユースケース:
# - AWSサービスのログをS3バケットに配信
# - ログデータをFirehoseストリームに配信して分析・アーカイブ
# - クロスアカウントでのログ配信
# - X-Rayへのトレースデータ配信
#
# 関連リソース:
# - aws_cloudwatch_log_group (配信先としてCloudWatch Logsログループを使用)
# - aws_s3_bucket (配信先としてS3バケットを使用)
# - aws_kinesis_firehose_delivery_stream (配信先としてFirehoseストリームを使用)

#-------
# 基本設定
#-------

resource "aws_cloudwatch_log_delivery" "example" {
  # 必須: 配信先のARN
  # 設定内容: 配信先となるCloudWatch Logsログループ、S3バケット、Firehoseストリーム、X-RayのARN
  # 注意: 配信先は事前にPutDeliveryDestination APIで作成しておく必要がある
  delivery_destination_arn = "arn:aws:logs:us-east-1:123456789012:delivery-destination:my-delivery-destination"

  # 必須: 配信ソース名
  # 設定内容: ログを送信するAWSリソースを表す論理的な配信ソースの名前
  # 制約: 1〜60文字、英数字、ハイフン、アンダースコアのみ使用可能
  # 注意: 配信ソースは事前にPutDeliverySource APIで作成しておく必要がある
  delivery_source_name = "my-delivery-source"

  #-------
  # ログフォーマット設定
  #-------

  # フィールド区切り文字
  # 設定内容: 配信されるレコードのフィールド間の区切り文字
  # 適用対象: Plain、W3C、Raw形式の出力フォーマットを使用する場合のみ有効
  # 制約: 0〜5文字
  # 省略時: デフォルトの区切り文字が使用される（配信先のタイプに依存）
  field_delimiter = "\t"

  # レコードフィールドリスト
  # 設定内容: 配信先に送信するレコードフィールドのリスト（送信順序も指定）
  # 注意: 配信ソースに必須フィールドがある場合、このリストに含める必要がある
  # 制約: 最大128個のフィールド、各フィールド名は1〜64文字
  # 省略時: デフォルトのレコードフィールドが使用される
  record_fields = [
    "@timestamp",
    "@message",
    "@logStream",
    "@logGroup"
  ]

  #-------
  # S3配信設定
  #-------

  # S3配信の詳細設定
  # 設定内容: 配信先がS3バケットの場合のみ有効なパラメータ
  s3_delivery_configuration {
    # Hive互換パス形式の有効化
    # 設定内容: S3バケット内でHive互換のパーティション形式（例: year=YYYY/month=MM/day=DD/hour=HH）を使用するか
    # 設定可能な値: true（有効）、false（無効）
    enable_hive_compatible_path = false

    # サフィックスパス
    # 設定内容: S3バケット内のオブジェクトキーに追加するカスタムサフィックスパス
    # 注意: カスタムパーティション構造を作成する場合に使用
    suffix_path = "logs/application/"
  }

  #-------
  # リージョン設定
  #-------

  # デプロイリージョン
  # 設定内容: このリソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンが使用される
  # 注意: クロスリージョン配信を設定する場合に明示的に指定
  region = "us-east-1"

  #-------
  # タグ設定
  #-------

  # リソースタグ
  # 設定内容: 配信リソースに付与するタグ（最大50個）
  # ユースケース: リソース管理、コスト配分、アクセス制御
  tags = {
    Name        = "example-log-delivery"
    Environment = "production"
    Service     = "logging"
  }
}

#-------
# Attributes Reference
#-------
# このリソースでは以下の属性がエクスポートされ、他のリソースから参照可能
#
# - id - 配信のID
# - arn - 配信のARN（Amazon Resource Name）
# - tags_all - デフォルトタグを含むすべてのタグのマップ（プロバイダーのdefault_tagsを含む）
#
# 補足:
# - 配信を作成する前に、配信ソース（PutDeliverySource）と配信先（PutDeliveryDestination）を事前に作成する必要がある
# - クロスアカウント配信の場合、配信先アカウントでPutDeliveryDestinationPolicyを使用してIAMポリシーを割り当てる必要がある
# - 既存の配信設定を更新する場合は、UpdateDeliveryConfiguration APIを使用する
# - field_delimiterとrecord_fieldsは配信作成後も変更可能（computed属性）
