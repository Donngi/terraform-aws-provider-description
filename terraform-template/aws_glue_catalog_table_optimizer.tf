#---------------------------------------------------------------
# AWS Glue Catalog Table Optimizer
#---------------------------------------------------------------
#
# AWS Glue Catalog Table Optimizerは、AWS Glue Data Catalog内のApache Iceberg
# テーブルに対して自動最適化を設定するためのリソースです。
# テーブルの圧縮（compaction）、スナップショット保持（retention）、
# 孤立ファイル削除（orphan_file_deletion）などの最適化を自動実行することで、
# クエリパフォーマンスの向上、メタデータオーバーヘッドの削減、
# ストレージコストの管理を実現します。
#
# AWS公式ドキュメント:
#   - Catalog-level table optimizers: https://docs.aws.amazon.com/glue/latest/dg/catalog-level-optimizers.html
#   - Enabling catalog-level automatic table optimization: https://docs.aws.amazon.com/glue/latest/dg/enable-auto-table-optimizers.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_table_optimizer
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_catalog_table_optimizer" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # catalog_id - (Required) The Catalog ID of the table.
  # AWS Glue Data CatalogのIDを指定します。通常はAWSアカウントIDと同じ12桁の数字です。
  catalog_id = "123456789012"

  # database_name - (Required) The name of the database in the catalog in which the table resides.
  # テーブルが存在するデータベースの名前を指定します。
  database_name = "example_database"

  # table_name - (Required) The name of the table.
  # 最適化対象のテーブル名を指定します。Apache Icebergテーブルである必要があります。
  table_name = "example_table"

  # type - (Required) The type of table optimizer.
  # テーブルオプティマイザーのタイプを指定します。
  # 有効な値:
  #   - "compaction": データファイルの圧縮を実行してクエリパフォーマンスを向上
  #   - "retention": スナップショットの保持期間を管理してストレージコストを制御
  #   - "orphan_file_deletion": テーブルメタデータから参照されていない孤立ファイルを削除
  type = "compaction"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # region - (Optional) Region where this resource will be managed.
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # region = "us-east-1"

  #---------------------------------------------------------------
  # Configuration Block (Required)
  #---------------------------------------------------------------

  # configuration - (Required) A configuration block that defines the table optimizer settings.
  # テーブルオプティマイザーの設定を定義するブロックです。
  configuration {
    # enabled - (Required) Indicates whether the table optimizer is enabled.
    # オプティマイザーを有効化するかどうかを指定します。
    # true: 有効化、false: 無効化
    enabled = true

    # role_arn - (Required) The ARN of the IAM role to use for the table optimizer.
    # テーブル最適化操作を実行するために使用するIAMロールのARNを指定します。
    # このロールには以下の権限が必要です:
    #   - Lake Formationで管理されているテーブルの場合: ALTER, DESCRIBE, INSERT, DELETE権限
    #   - S3バケットへのアクセス権限
    #   - Glueテーブルの読み取り/書き込み権限
    role_arn = "arn:aws:iam::123456789012:role/GlueTableOptimizerRole"

    #---------------------------------------------------------------
    # Retention Configuration Block (Optional)
    #---------------------------------------------------------------

    # retention_configuration - (Optional) Configuration for snapshot retention optimization.
    # スナップショット保持の最適化設定を定義します。
    # type = "retention" の場合に使用します。
    # retention_configuration {
    #   # iceberg_configuration - (Optional) Iceberg-specific retention settings.
    #   iceberg_configuration {
    #     # snapshot_retention_period_in_days - (Optional) Number of days to retain snapshots.
    #     # スナップショットを保持する日数を指定します。
    #     # この期間を過ぎたスナップショットは削除対象となります。
    #     snapshot_retention_period_in_days = 7
    #
    #     # number_of_snapshots_to_retain - (Optional) Minimum number of snapshots to retain.
    #     # 保持する最小スナップショット数を指定します。
    #     # この数以下のスナップショットは、保持期間に関係なく保持されます。
    #     number_of_snapshots_to_retain = 3
    #
    #     # clean_expired_files - (Optional) Whether to clean up expired files.
    #     # 期限切れファイルをクリーンアップするかどうかを指定します。
    #     # true: 期限切れファイルを削除、false: 削除しない
    #     clean_expired_files = true
    #
    #     # run_rate_in_hours - (Optional, Computed) How often to run the optimizer in hours.
    #     # オプティマイザーを実行する間隔（時間単位）を指定します。
    #     # 指定しない場合、デフォルト値が計算されます。
    #     # run_rate_in_hours = 24
    #   }
    # }

    #---------------------------------------------------------------
    # Orphan File Deletion Configuration Block (Optional)
    #---------------------------------------------------------------

    # orphan_file_deletion_configuration - (Optional) Configuration for orphan file deletion.
    # 孤立ファイル削除の最適化設定を定義します。
    # type = "orphan_file_deletion" の場合に使用します。
    # orphan_file_deletion_configuration {
    #   # iceberg_configuration - (Optional) Iceberg-specific orphan file deletion settings.
    #   iceberg_configuration {
    #     # orphan_file_retention_period_in_days - (Optional) Number of days to retain orphan files.
    #     # 孤立ファイルを保持する日数を指定します。
    #     # この期間を過ぎた孤立ファイルが削除対象となります。
    #     # 最近のデータ更新で一時的に孤立状態になっているファイルを
    #     # 誤って削除しないよう、適切な保持期間を設定してください。
    #     orphan_file_retention_period_in_days = 7
    #
    #     # location - (Optional) S3 location to scan for orphan files.
    #     # 孤立ファイルをスキャンするS3ロケーションを指定します。
    #     # 指定しない場合、テーブルのルートロケーションが使用されます。
    #     # 例: "s3://example-bucket/example_table/"
    #     location = "s3://example-bucket/example_table/"
    #
    #     # run_rate_in_hours - (Optional, Computed) How often to run the optimizer in hours.
    #     # オプティマイザーを実行する間隔（時間単位）を指定します。
    #     # 指定しない場合、デフォルト値が計算されます。
    #     # 複数のテーブルで同時にオプティマイザーを実行する場合、
    #     # サービス制限を回避するためランダムな遅延が導入されます。
    #     # run_rate_in_hours = 24
    #   }
    # }
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースには、以下の計算済み属性（Computed Attributes）が含まれますが、
# これらは入力パラメータではなく、Terraform実行後に参照可能な出力値です。
#
# - id: リソースの一意識別子（自動生成）
# - configuration.retention_configuration.iceberg_configuration.run_rate_in_hours:
#     保持オプティマイザーの実行間隔（指定しない場合は自動計算）
# - configuration.orphan_file_deletion_configuration.iceberg_configuration.run_rate_in_hours:
#     孤立ファイル削除オプティマイザーの実行間隔（指定しない場合は自動計算）
#
# 参照方法:
#   aws_glue_catalog_table_optimizer.example.id
#   aws_glue_catalog_table_optimizer.example.configuration[0].retention_configuration[0].iceberg_configuration[0].run_rate_in_hours
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Usage Examples
#---------------------------------------------------------------

# Example 1: Compaction Optimizer
# データファイルの圧縮を自動実行し、クエリパフォーマンスを向上させます。
#
# resource "aws_glue_catalog_table_optimizer" "compaction" {
#   catalog_id    = "123456789012"
#   database_name = "analytics_db"
#   table_name    = "events_table"
#   type          = "compaction"
#
#   configuration {
#     role_arn = aws_iam_role.glue_optimizer.arn
#     enabled  = true
#   }
# }

# Example 2: Snapshot Retention Optimizer
# スナップショットの保持期間を管理し、ストレージコストを制御します。
#
# resource "aws_glue_catalog_table_optimizer" "retention" {
#   catalog_id    = "123456789012"
#   database_name = "analytics_db"
#   table_name    = "events_table"
#   type          = "retention"
#
#   configuration {
#     role_arn = aws_iam_role.glue_optimizer.arn
#     enabled  = true
#
#     retention_configuration {
#       iceberg_configuration {
#         snapshot_retention_period_in_days = 7
#         number_of_snapshots_to_retain     = 3
#         clean_expired_files               = true
#         run_rate_in_hours                 = 24
#       }
#     }
#   }
# }

# Example 3: Orphan File Deletion Optimizer
# テーブルメタデータから参照されていない孤立ファイルを自動削除します。
#
# resource "aws_glue_catalog_table_optimizer" "orphan_deletion" {
#   catalog_id    = "123456789012"
#   database_name = "analytics_db"
#   table_name    = "events_table"
#   type          = "orphan_file_deletion"
#
#   configuration {
#     role_arn = aws_iam_role.glue_optimizer.arn
#     enabled  = true
#
#     orphan_file_deletion_configuration {
#       iceberg_configuration {
#         orphan_file_retention_period_in_days = 7
#         location                             = "s3://my-data-lake/events_table/"
#         run_rate_in_hours                    = 24
#       }
#     }
#   }
# }

#---------------------------------------------------------------
# Notes
#---------------------------------------------------------------
# - このリソースはApache Icebergテーブルに対してのみ使用可能です
# - テーブルレベルの最適化設定は、カタログレベルの設定よりも優先されます
# - 複数のテーブルで最適化を有効にする場合、サービス制限に注意してください
# - IAMロールには適切な権限（Lake Formation権限、S3アクセス権限等）が必要です
# - カタログレベルでオプティマイザーを無効化すると、全テーブルに影響します
#   （既にテーブルレベルで設定されているものを除く）
#---------------------------------------------------------------
