#---------------------------------------------------------------
# AWS DynamoDB Table Export
#---------------------------------------------------------------
#
# DynamoDB テーブルのデータを Amazon S3 にエクスポートするためのリソースです。
# Terraform はエクスポートのステータスが `COMPLETED` または `FAILED` になるまで待機します。
#
# エクスポートの種類:
#   - FULL_EXPORT: テーブル全体のスナップショットをエクスポート
#   - INCREMENTAL_EXPORT: 指定した時間範囲の変更のみをエクスポート
#
# 重要な前提条件:
#   - 対象の DynamoDB テーブルで Point-in-Time Recovery (PITR) が有効である必要があります
#
# 注意事項:
#   - 一度作成された Table Export は変更不可 (イミュータブル) です
#   - AWS API では削除操作をサポートしていません
#   - destroy 実行時は Terraform の state から削除されるのみで、エクスポートされたデータは削除されません
#
# AWS公式ドキュメント:
#   - DynamoDB Export の仕組み: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/S3DataExport.HowItWorks.html
#   - Export のリクエスト: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/S3DataExport_Requesting.html
#   - Export の出力形式: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/S3DataExport.Output.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table_export
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dynamodb_table_export" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # table_arn (Required, Forces new resource)
  # 設定内容: エクスポート対象の DynamoDB テーブルの ARN を指定します。
  # 設定可能な値: 有効な DynamoDB テーブルの ARN
  # 注意: 対象テーブルで Point-in-Time Recovery (PITR) が有効である必要があります
  # 関連機能: DynamoDB テーブル ARN
  #   エクスポートするテーブルを一意に識別するための Amazon Resource Name。
  #   - https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/S3DataExport_Requesting.html
  table_arn = "arn:aws:dynamodb:ap-northeast-1:123456789012:table/example-table"

  # s3_bucket (Required, Forces new resource)
  # 設定内容: エクスポートデータの保存先となる S3 バケット名を指定します。
  # 設定可能な値: 有効な S3 バケット名
  # 注意: バケットに適切な権限設定が必要です
  # 関連機能: S3 エクスポート先バケット
  #   DynamoDB がエクスポートデータを書き込むための権限が必要。
  #   - https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/S3DataExport_Requesting.html#S3DataExport_Requesting_Permissions
  s3_bucket = "example-export-bucket"

  #-------------------------------------------------------------
  # S3 出力設定
  #-------------------------------------------------------------

  # s3_bucket_owner (Optional, Computed, Forces new resource)
  # 設定内容: エクスポート先 S3 バケットを所有する AWS アカウント ID を指定します。
  # 設定可能な値: 12桁の AWS アカウント ID
  # 省略時: エクスポートを実行するアカウントがバケット所有者として使用されます
  # 用途: クロスアカウントでのエクスポート時に指定
  s3_bucket_owner = null

  # s3_prefix (Optional, Computed, Forces new resource)
  # 設定内容: エクスポートされるスナップショットのファイル名とパスに使用する S3 プレフィックスを指定します。
  # 設定可能な値: 有効な S3 オブジェクトキープレフィックス (例: "exports/dynamodb/")
  # 省略時: バケットのルートにエクスポートされます
  # 用途: エクスポートデータを整理するために使用
  s3_prefix = null

  # s3_sse_algorithm (Optional, Computed, Forces new resource)
  # 設定内容: エクスポートデータの保存先バケットで使用する暗号化アルゴリズムを指定します。
  # 設定可能な値:
  #   - "AES256": S3 マネージドキーによる暗号化 (SSE-S3)
  #   - "KMS": AWS KMS マネージドキーによる暗号化 (SSE-KMS)
  # 省略時: バケットのデフォルト暗号化設定が使用されます
  s3_sse_algorithm = null

  # s3_sse_kms_key_id (Optional, Forces new resource)
  # 設定内容: S3 バケットの暗号化に使用する AWS KMS マネージドキーの ID を指定します。
  # 設定可能な値: 有効な KMS キー ID または ARN
  # 注意: s3_sse_algorithm が "KMS" の場合にのみ適用されます
  # 用途: カスタム KMS キーでエクスポートデータを暗号化する場合に使用
  s3_sse_kms_key_id = null

  #-------------------------------------------------------------
  # エクスポート設定
  #-------------------------------------------------------------

  # export_format (Optional, Forces new resource)
  # 設定内容: エクスポートデータの形式を指定します。
  # 設定可能な値:
  #   - "DYNAMODB_JSON" (デフォルト): DynamoDB JSON 形式。属性の型情報を含む
  #   - "ION": Amazon Ion 形式。コンパクトで効率的なデータ形式
  # 関連機能: エクスポートデータ形式
  #   各形式の詳細と使用方法について。
  #   - https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/S3DataExport.Output.html#S3DataExport.Output_Data
  export_format = "DYNAMODB_JSON"

  # export_time (Optional, Computed, Forces new resource)
  # 設定内容: テーブルデータをエクスポートする時点を RFC3339 形式で指定します。
  # 設定可能な値: RFC3339 形式の日時文字列 (例: "2023-04-02T11:30:13+01:00")
  # 省略時: 現在時刻のスナップショットがエクスポートされます
  # 注意: 指定した時点のテーブル状態のスナップショットがエクスポートされます
  # 用途: 特定の時点のデータをエクスポートする場合に使用
  export_time = null

  # export_type (Optional, Computed, Forces new resource)
  # 設定内容: フルエクスポートまたはインクリメンタルエクスポートを指定します。
  # 設定可能な値:
  #   - "FULL_EXPORT" (デフォルト): テーブル全体のスナップショットをエクスポート
  #   - "INCREMENTAL_EXPORT": 指定した時間範囲の変更のみをエクスポート
  # 注意: "INCREMENTAL_EXPORT" を指定する場合、incremental_export_specification ブロックも必須
  export_type = "FULL_EXPORT"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # インクリメンタルエクスポート設定
  #-------------------------------------------------------------

  # incremental_export_specification (Optional, Forces new resource)
  # 設定内容: インクリメンタルエクスポート固有のパラメータを設定します。
  # 注意: export_type が "INCREMENTAL_EXPORT" の場合に必須
  # incremental_export_specification {
  #   # export_from_time (Optional, Computed)
  #   # 設定内容: インクリメンタルエクスポートの開始時刻を RFC3339 形式で指定します。
  #   # 設定可能な値: RFC3339 形式の日時文字列 (例: "2025-02-09T12:00:00+01:00")
  #   # 用途: エクスポートする変更の開始時点を指定
  #   export_from_time = "2025-02-09T12:00:00+01:00"
  #
  #   # export_to_time (Optional, Computed)
  #   # 設定内容: インクリメンタルエクスポートの終了時刻を RFC3339 形式で指定します。
  #   # 設定可能な値: RFC3339 形式の日時文字列 (例: "2025-02-09T13:00:00+01:00")
  #   # 用途: エクスポートする変更の終了時点を指定
  #   export_to_time = "2025-02-09T13:00:00+01:00"
  #
  #   # export_view_type (Optional, Computed)
  #   # 設定内容: インクリメンタルエクスポートのビュータイプを指定します。
  #   # 設定可能な値:
  #   #   - "NEW_IMAGE": 変更後のアイテムの最新状態をエクスポート
  #   #   - "NEW_AND_OLD_IMAGES": 変更前後のアイテムの状態をエクスポート
  #   # 用途: エクスポートするデータの詳細レベルを制御
  #   export_view_type = null
  # }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト値を設定します。
  # timeouts {
  #   # create (Optional)
  #   # 設定内容: リソース作成時のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列 (例: "60m", "2h")
  #   # 省略時: プロバイダーのデフォルト値
  #   # 用途: 大きなテーブルのエクスポートには長いタイムアウトが必要な場合があります
  #   create = null
  #
  #   # delete (Optional)
  #   # 設定内容: リソース削除時のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列 (例: "30m", "1h")
  #   # 省略時: プロバイダーのデフォルト値
  #   delete = null
  # }

  #-------------------------------------------------------------
  # ID 設定
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: リソースの ID
  # 注意: 通常は明示的に設定する必要はありません。Terraform が自動管理します
  # id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: テーブルエクスポートの Amazon Resource Name (ARN)
#
# - billed_size_in_bytes: テーブルエクスポートの課金対象サイズ (バイト単位)
#
# - end_time: エクスポートタスクが完了した時刻
#
# - export_status: エクスポートのステータス
#   設定可能な値:
#   - IN_PROGRESS: エクスポート処理中
#   - COMPLETED: エクスポート完了
#   - FAILED: エクスポート失敗
#
# - item_count: エクスポートされたアイテム数
#
# - manifest_files_s3_key: エクスポートタスクのマニフェストファイルの S3 キー名
#   マニフェストファイルについて:
#   - https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/S3DataExport.Output.html#S3DataExport.Output_Manifest
#
# - start_time: エクスポートタスクが開始された時刻
#---------------------------------------------------------------
