#-------
# DynamoDB Table Export
#-------
# Provider Version: 6.28.0
# Generated: 2026-02-14
#
# 用途: DynamoDBテーブルのデータを指定した時点でS3バケットにエクスポートする
# 補足:
#   - テーブルでPoint-in-Time Recovery（PITR）が有効化されている必要がある
#   - エクスポートは非同期で実行され、テーブルのパフォーマンスに影響を与えない
#   - 読み取りキャパシティユニットを消費しない
#   - フルエクスポートまたは増分エクスポートをサポート
#   - DynamoDB JSON形式またはAmazon Ion形式で出力可能
# 公式ドキュメント: https://docs.aws.amazon.com/ja_jp/amazondynamodb/latest/developerguide/S3DataExport.html
# Terraformドキュメント: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/dynamodb_table_export
#
# NOTE:
#   - エクスポートメタデータは90日後に自動的に削除される
#   - エクスポートされたデータの削除はDynamoDBでは行われない（S3で手動削除が必要）
#   - クロスアカウント・クロスリージョンエクスポートをサポート

#-------
# 基本設定
#-------
resource "aws_dynamodb_table_export" "example" {
  # 必須: エクスポート元のDynamoDBテーブルのARN
  # 設定内容: エクスポート対象のテーブルを識別するARN（PITRが有効化されている必要がある）
  table_arn = "arn:aws:dynamodb:ap-northeast-1:123456789012:table/example-table"

  # 必須: エクスポート先のS3バケット名
  # 設定内容: エクスポートデータを保存するS3バケットの名前
  s3_bucket = "example-export-bucket"

  #-------
  # エクスポート形式とタイミング
  #-------
  # エクスポート形式
  # 設定可能な値: DYNAMODB_JSON（DynamoDB JSON形式）、ION（Amazon Ion形式）
  # 省略時: DYNAMODB_JSON
  export_format = "DYNAMODB_JSON"

  # エクスポートタイプ
  # 設定可能な値: FULL_EXPORT（フルエクスポート）、INCREMENTAL_EXPORT（増分エクスポート）
  # 省略時: FULL_EXPORT
  export_type = "FULL_EXPORT"

  # エクスポート時点（RFC3339形式のタイムスタンプ）
  # 設定内容: エクスポートするデータの時点（PITR期間内の任意の時点を指定可能）
  # 省略時: 現在時刻
  export_time = "2024-01-01T00:00:00Z"

  #-------
  # S3出力設定
  #-------
  # S3バケット内のプレフィックス（フォルダパス）
  # 設定内容: エクスポートデータを保存するS3キーのプレフィックス
  # 省略時: バケットのルートに保存
  s3_prefix = "dynamodb-exports/"

  # S3バケットの所有者アカウントID
  # 設定内容: クロスアカウントエクスポート時の宛先バケット所有者のAWSアカウントID
  # 省略時: 現在のアカウント
  s3_bucket_owner = "123456789012"

  # S3サーバー側暗号化アルゴリズム
  # 設定可能な値: AES256（SSE-S3）、aws:kms（SSE-KMS）
  # 省略時: AES256
  s3_sse_algorithm = "aws:kms"

  # SSE-KMS使用時の暗号化キーID
  # 設定内容: S3でSSE-KMSを使用する場合のKMSキーARNまたはキーID
  # 補足: s3_sse_algorithmが"aws:kms"の場合に指定
  s3_sse_kms_key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #-------
  # リージョン設定
  #-------
  # エクスポートを管理するAWSリージョン
  # 設定内容: エクスポートリソースを管理するリージョン
  # 省略時: プロバイダーのリージョン設定を使用
  region = "ap-northeast-1"

  #-------
  # 増分エクスポート設定
  #-------
  # 増分エクスポートの仕様（export_type = "INCREMENTAL_EXPORT" の場合に使用）
  # incremental_export_specification {
  #   # エクスポート開始時刻（RFC3339形式）
  #   # 設定内容: 増分エクスポートの対象期間の開始時点
  #   # 省略時: PITR期間の最も古い時点
  #   export_from_time = "2024-01-01T00:00:00Z"
  #
  #   # エクスポート終了時刻（RFC3339形式）
  #   # 設定内容: 増分エクスポートの対象期間の終了時点
  #   # 省略時: 現在時刻
  #   export_to_time = "2024-01-02T00:00:00Z"
  #
  #   # エクスポートビュータイプ
  #   # 設定可能な値: NEW_IMAGE（変更後のイメージ）、OLD_IMAGE（変更前のイメージ）、NEW_AND_OLD_IMAGES（両方）
  #   # 省略時: NEW_AND_OLD_IMAGES
  #   export_view_type = "NEW_AND_OLD_IMAGES"
  # }

  #-------
  # タイムアウト設定
  #-------
  timeouts {
    # エクスポート作成のタイムアウト時間
    # 設定内容: エクスポートジョブの完了を待機する最大時間
    # 省略時: 60分
    # create = "60m"

    # エクスポート削除のタイムアウト時間
    # 設定内容: エクスポートメタデータの削除を待機する最大時間
    # 省略時: 10分
    # delete = "10m"
  }
}

#-------
# Attributes Reference（参照専用属性）
#-------
# このリソースは以下の属性を出力します:
#
# - id: エクスポートのARN
# - arn: エクスポートのARN（IDと同値）
# - export_status: エクスポートのステータス（IN_PROGRESS、COMPLETED、FAILED）
# - billed_size_in_bytes: エクスポート時のテーブルサイズ（バイト単位、課金対象サイズ）
# - item_count: エクスポートされたアイテム数
# - start_time: エクスポートジョブの開始時刻（RFC3339形式）
# - end_time: エクスポートジョブの終了時刻（RFC3339形式）
# - manifest_files_s3_key: エクスポートマニフェストファイルのS3キー
