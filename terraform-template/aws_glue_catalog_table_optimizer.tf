#---------------------------------------------------------------
# AWS Glue カタログテーブルオプティマイザー
#---------------------------------------------------------------
#
# AWS Glue Data Catalog のテーブルに対してオプティマイザーを設定するリソースです。
# テーブルオプティマイザーは、Icebergテーブルの圧縮（コンパクション）、
# スナップショットの保持管理、孤立ファイルの削除などを自動的に実行することで
# テーブルのパフォーマンスとストレージ効率を最適化します。
#
# AWS公式ドキュメント:
#   - AWS Glue テーブルオプティマイザー: https://docs.aws.amazon.com/glue/latest/dg/table-optimizer.html
#   - Iceberg テーブル管理: https://docs.aws.amazon.com/glue/latest/dg/aws-glue-catalog-iceberg.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_table_optimizer
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_catalog_table_optimizer" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # catalog_id (Required)
  # 設定内容: Glue Data Catalog のカタログIDを指定します。
  # 設定可能な値: AWSアカウントID（12桁の数字）
  catalog_id = "123456789012"

  # database_name (Required)
  # 設定内容: オプティマイザーを設定するテーブルが属するデータベース名を指定します。
  # 設定可能な値: Glue Data Catalog 内の既存データベース名
  database_name = "example_database"

  # table_name (Required)
  # 設定内容: オプティマイザーを適用するテーブル名を指定します。
  # 設定可能な値: 指定したデータベース内の既存テーブル名（Icebergテーブルである必要があります）
  table_name = "example_table"

  # type (Required)
  # 設定内容: テーブルオプティマイザーの種類を指定します。
  # 設定可能な値:
  #   - "compaction": Icebergテーブルのデータファイルを圧縮してパフォーマンスを向上させます
  #   - "retention": 古いスナップショットを削除してストレージコストを削減します
  #   - "orphan_file_deletion": 参照されていない孤立ファイルを削除してストレージを最適化します
  type = "compaction"

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
  # オプティマイザー設定
  #-------------------------------------------------------------

  # configuration (Required)
  # 設定内容: テーブルオプティマイザーの動作設定を指定するブロックです。
  #          有効化フラグ、実行ロール、および各オプティマイザー種別固有の設定を含みます。
  configuration {
    # enabled (Required)
    # 設定内容: テーブルオプティマイザーを有効にするかどうかを指定します。
    # 設定可能な値: true（有効）, false（無効）
    enabled = true

    # role_arn (Required)
    # 設定内容: テーブルオプティマイザーがテーブルへのアクセスや操作を実行する際に
    #          引き受けるIAMロールのARNを指定します。
    # 設定可能な値: IAMロールのARN
    # 注意: 指定するIAMロールには、Glue、S3、CloudWatch Logsへの
    #       適切なアクセス権限を付与する必要があります
    role_arn = "arn:aws:iam::123456789012:role/glue-table-optimizer-role"

    #-----------------------------------------------------------
    # 保持設定 (retention_configuration)
    #-----------------------------------------------------------
    # type = "retention" の場合に使用します。
    # 古いIcebergスナップショットを自動的に削除するポリシーを定義します。
    # 参考: https://docs.aws.amazon.com/glue/latest/dg/table-optimizer-retention.html
    retention_configuration {
      # iceberg_configuration (Optional)
      # 設定内容: Icebergテーブルのスナップショット保持設定を指定するブロックです。
      iceberg_configuration {
        # clean_expired_files (Optional)
        # 設定内容: 期限切れスナップショットによって参照されなくなったファイルを
        #          削除するかどうかを指定します。
        # 設定可能な値: true（削除する）, false（削除しない）
        # 省略時: false
        clean_expired_files = true

        # number_of_snapshots_to_retain (Optional)
        # 設定内容: 保持するスナップショットの最小数を指定します。
        # 設定可能な値: 正の整数
        # 省略時: プロバイダーのデフォルト値
        number_of_snapshots_to_retain = 5

        # snapshot_retention_period_in_days (Optional)
        # 設定内容: スナップショットを保持する期間を日数で指定します。
        #          この期間を超えたスナップショットは削除対象となります。
        # 設定可能な値: 正の整数（日数）
        # 省略時: プロバイダーのデフォルト値
        snapshot_retention_period_in_days = 7

        # run_rate_in_hours (Optional)
        # 設定内容: オプティマイザーの実行間隔を時間単位で指定します。
        # 設定可能な値: 正の整数（時間）
        # 省略時: AWSが自動的に設定（computed）
        run_rate_in_hours = 24
      }
    }

    #-----------------------------------------------------------
    # 孤立ファイル削除設定 (orphan_file_deletion_configuration)
    #-----------------------------------------------------------
    # type = "orphan_file_deletion" の場合に使用します。
    # Icebergテーブルのスナップショットから参照されていない孤立ファイルを
    # 自動的に削除するポリシーを定義します。
    # 参考: https://docs.aws.amazon.com/glue/latest/dg/table-optimizer-orphan-file.html
    orphan_file_deletion_configuration {
      # iceberg_configuration (Optional)
      # 設定内容: Icebergテーブルの孤立ファイル削除設定を指定するブロックです。
      iceberg_configuration {
        # location (Optional)
        # 設定内容: 孤立ファイルを検索するS3の場所（パス）を指定します。
        # 設定可能な値: S3パス（例: s3://my-bucket/my-table/）
        # 省略時: テーブルのデータロケーションを使用
        location = "s3://example-bucket/example-table/"

        # orphan_file_retention_period_in_days (Optional)
        # 設定内容: ファイルを孤立ファイルと判定するまでの保持期間を日数で指定します。
        #          この期間より古く、かつどのスナップショットからも参照されていない
        #          ファイルが削除対象となります。
        # 設定可能な値: 正の整数（日数）
        # 省略時: プロバイダーのデフォルト値
        orphan_file_retention_period_in_days = 3

        # run_rate_in_hours (Optional)
        # 設定内容: 孤立ファイル削除オプティマイザーの実行間隔を時間単位で指定します。
        # 設定可能な値: 正の整数（時間）
        # 省略時: AWSが自動的に設定（computed）
        run_rate_in_hours = 24
      }
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: カタログID、データベース名、テーブル名、タイプを組み合わせた識別子
#---------------------------------------------------------------
