#---------------------------------------------------------------
# Amazon S3 Tables - Table Bucket
#---------------------------------------------------------------
#
# Amazon S3 Tables のテーブルバケットを管理するリソースです。
# テーブルバケットは Apache Iceberg テーブル形式に最適化されたストレージで、
# 分析ワークロード向けに高いパフォーマンスとスループットを提供します。
#
# 主な特徴:
#   - Apache Iceberg V2 / V3 テーブル形式を自動管理
#   - コンパクション等のメンテナンスを自動実行
#   - 未参照ファイル自動削除による削減コスト削減
#   - SSE-S3 / SSE-KMS によるサーバーサイド暗号化をサポート
#   - AWS Glue / Athena / Amazon Redshift 等のサービスと統合
#
# AWS公式ドキュメント:
#   - S3 Tables 概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables.html
#   - テーブルバケット作成: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-create-table-bucket.html
#   - メンテナンス設定: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-maintenance.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3tables_table_bucket
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3tables_table_bucket" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: テーブルバケットの名前を指定します。
  # 設定可能な値: 小文字英数字およびハイフンを含む 3〜63 文字の文字列。
  #   AWSアカウントおよびリージョンをまたいでグローバルに一意である必要があります。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-create-table-bucket.html
  name = "my-table-bucket"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # encryption_configuration (Optional)
  # 設定内容: テーブルバケットのサーバーサイド暗号化設定を指定します。
  # 省略時: SSE-S3 (AES256) によるデフォルト暗号化が適用されます。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-encryption.html
  encryption_configuration = {
    # sse_algorithm (Required)
    # 設定内容: 使用するサーバーサイド暗号化アルゴリズムを指定します。
    # 設定可能な値:
    #   - "AES256": SSE-S3（Amazon S3 管理キーによる暗号化）
    #   - "aws:kms": SSE-KMS（AWS KMS 管理キーによる暗号化）
    sse_algorithm = "aws:kms"

    # kms_key_arn (Optional)
    # 設定内容: SSE-KMS 暗号化に使用する KMS キーの ARN を指定します。
    # 設定可能な値: 有効な KMS キー ARN
    # 省略時: sse_algorithm が "aws:kms" の場合はデフォルトの aws/s3tables KMS キーを使用
    # 注意: sse_algorithm が "aws:kms" の場合のみ有効
    kms_key_arn = null
  }

  #-------------------------------------------------------------
  # メンテナンス設定
  #-------------------------------------------------------------

  # maintenance_configuration (Optional, Computed)
  # 設定内容: テーブルバケットのメンテナンス動作を設定します。
  # 省略時: AWSがデフォルトのメンテナンス設定を適用します。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-maintenance.html
  maintenance_configuration = {
    # iceberg_unreferenced_file_removal (Required)
    # 設定内容: Iceberg テーブルの未参照ファイル削除ジョブの設定を指定します。
    #   未参照ファイルとは、アクティブなスナップショットから参照されていない
    #   データファイルおよびメタデータファイルです。
    iceberg_unreferenced_file_removal = {
      # status (Required)
      # 設定内容: 未参照ファイル削除ジョブのステータスを指定します。
      # 設定可能な値:
      #   - "enabled": ジョブを有効化
      #   - "disabled": ジョブを無効化
      status = "enabled"

      # settings (Optional)
      # 設定内容: 未参照ファイル削除ジョブの詳細パラメーターを指定します。
      settings = {
        # non_current_days (Required)
        # 設定内容: 非現行（古いスナップショットの）メタデータファイルを
        #   削除するまでの日数を指定します。
        # 設定可能な値: 正の整数（日数）
        non_current_days = 90

        # unreferenced_days (Required)
        # 設定内容: 未参照データファイルを削除するまでの日数を指定します。
        #   スナップショットにより保護されない孤立したデータファイルが対象です。
        # 設定可能な値: 正の整数（日数）
        unreferenced_days = 3
      }
    }
  }

  #-------------------------------------------------------------
  # ライフサイクル設定
  #-------------------------------------------------------------

  # force_destroy (Optional, Computed)
  # 設定内容: テーブルバケット削除時にバケット内の全テーブルを
  #   強制的に削除するかを指定します。
  # 設定可能な値:
  #   - true: destroy 時にテーブルを全削除してからバケットを削除
  #   - false: テーブルが残っている場合は destroy が失敗
  # 省略時: false
  # 注意: true に設定後、次の terraform apply が成功してから destroy を実行する必要があります。
  force_destroy = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  tags = {
    Name        = "my-table-bucket"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: テーブルバケットの ARN
# - created_at: テーブルバケットが作成された日時 (ISO 8601 形式)
# - owner_account_id: テーブルバケットを所有する AWS アカウント ID
# - tags_all: プロバイダーの default_tags 設定から継承されたタグを含む全タグマップ
#---------------------------------------------------------------
