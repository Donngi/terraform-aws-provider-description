#---------------------------------------------------------------
# AWS RDS Export Task
#---------------------------------------------------------------
#
# Amazon RDSのDBスナップショットまたはDBクラスターのデータを
# Amazon S3バケットにエクスポートするタスクをプロビジョニングするリソースです。
# エクスポートされたデータはApache Parquet形式で保存され、
# Amazon AthenaやAmazon Redshift Spectrumを使用した分析が可能です。
#
# AWS公式ドキュメント:
#   - DBスナップショットデータのS3エクスポート: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ExportSnapshot.html
#   - StartExportTask APIリファレンス: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_StartExportTask.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_export_task
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rds_export_task" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # export_task_identifier (Required)
  # 設定内容: スナップショットエクスポートタスクの一意な識別子を指定します。
  # 設定可能な値: 1-255文字の英数字、ハイフン（-）を含む文字列
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_StartExportTask.html
  export_task_identifier = "example-export-task"

  # source_arn (Required)
  # 設定内容: エクスポート対象のDBスナップショットまたはDBクラスタースナップショットのARNを指定します。
  # 設定可能な値: 有効なDBスナップショットまたはDBクラスタースナップショットのARN
  # 注意: エクスポート元のスナップショットは "available" 状態である必要があります。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ExportSnapshot.html
  source_arn = "arn:aws:rds:ap-northeast-1:123456789012:snapshot:example-snapshot"

  #-------------------------------------------------------------
  # IAM設定
  #-------------------------------------------------------------

  # iam_role_arn (Required)
  # 設定内容: Amazon S3バケットへの書き込みに使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: IAMロールには以下のアクセス許可が必要です:
  #   - s3:PutObject、s3:GetObject、s3:ListBucket、s3:DeleteObject、s3:GetBucketLocation
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ExportSnapshot.html
  iam_role_arn = "arn:aws:iam::123456789012:role/example-rds-export-role"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Required)
  # 設定内容: Amazon S3へのエクスポート時にスナップショットの暗号化に使用するKMSキーのIDを指定します。
  # 設定可能な値: KMSキーID、キーARN、エイリアス名、またはエイリアスARN
  # 注意: KMSキーポリシーでkms:CreateGrantとkms:DescribeKeyの実行を許可する必要があります。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ExportSnapshot.html
  kms_key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #-------------------------------------------------------------
  # エクスポート先設定
  #-------------------------------------------------------------

  # s3_bucket_name (Required)
  # 設定内容: スナップショットをエクスポートするAmazon S3バケットの名前を指定します。
  # 設定可能な値: 有効なS3バケット名
  # 注意: S3バケットはエクスポートタスクと同一リージョンに存在する必要があります。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ExportSnapshot.html
  s3_bucket_name = "example-rds-export-bucket"

  # s3_prefix (Optional)
  # 設定内容: エクスポートされたスナップショットのファイル名とパスとして使用するS3バケットプレフィックスを指定します。
  # 設定可能な値: S3オブジェクトキープレフィックスの文字列
  # 省略時: プレフィックスなしでバケットのルートに配置されます。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_StartExportTask.html
  s3_prefix = "my-exports/example"

  #-------------------------------------------------------------
  # エクスポートデータ選択設定
  #-------------------------------------------------------------

  # export_only (Optional)
  # 設定内容: スナップショットからエクスポートするデータを指定します。
  # 設定可能な値:
  #   - "database": 指定したデータベースのすべてのデータ
  #   - "database.table": スナップショットまたはクラスターの特定テーブル（例: "mydatabase.mytable"）
  #   - "database.schema": スナップショットまたはクラスターのデータベーススキーマ（例: "mydatabase.myschema"）
  #   - "database.schema.table": データベーススキーマの特定テーブル（例: "mydatabase.myschema.mytable"）
  # 省略時: スナップショットの全データがエクスポートされます。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_StartExportTask.html#API_StartExportTask_RequestParameters
  export_only = ["database"]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定するブロックです。
  timeouts {
    # create (Optional)
    # 設定内容: エクスポートタスク作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s"、"2h45m" のような期間文字列。単位: "s"（秒）、"m"（分）、"h"（時間）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    create = "120m"

    # delete (Optional)
    # 設定内容: エクスポートタスク削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s"、"2h45m" のような期間文字列。単位: "s"（秒）、"m"（分）、"h"（時間）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: スナップショットエクスポートタスクの一意な識別子（export_task_identifierと同値）
# - failure_cause: エクスポートが失敗した場合の失敗理由
# - percent_progress: スナップショットエクスポートタスクの進捗率（パーセント）
# - snapshot_time: スナップショットが作成された時刻
# - source_type: エクスポートのソースタイプ（"SNAPSHOT" または "CLUSTER"）
# - status: エクスポートタスクのステータス
#           （canceled, canceling, complete, failed, in-progress, starting）
# - task_end_time: スナップショットエクスポートタスクが完了した時刻
# - task_start_time: スナップショットエクスポートタスクが開始した時刻
# - warning_message: エクスポートタスクに関する警告メッセージ（存在する場合）
#---------------------------------------------------------------
