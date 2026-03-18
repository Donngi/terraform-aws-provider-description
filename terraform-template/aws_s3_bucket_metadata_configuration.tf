#---------------------------------------------------------------
# AWS S3 Bucket Metadata Configuration
#---------------------------------------------------------------
#
# S3バケットのメタデータ設定リソースをプロビジョニングします。
# このリソースは、S3バケットのメタデータテーブル（インベントリテーブルおよびジャーナルテーブル）を管理し、
# S3オブジェクトのメタデータをS3 Tables経由でクエリ可能な形式で保存します。
#
# 注意: expected_bucket_owner属性は非推奨（Deprecated）です。
#
# AWS公式ドキュメント:
#   - S3 Metadata概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-metadata.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_metadata_configuration
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket_metadata_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Required)
  # 設定内容: メタデータ設定を作成する対象の汎用S3バケット名を指定します。
  # 設定可能な値: 既存のS3バケット名
  bucket = "example-bucket"

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
  # 非推奨設定
  #-------------------------------------------------------------

  # expected_bucket_owner (Optional, Deprecated, Forces new resource)
  # 設定内容: バケット所有者として想定されるAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: 所有者検証を行わない
  # 注意: この属性は非推奨です。将来のバージョンで削除される予定です。
  expected_bucket_owner = null

  #-------------------------------------------------------------
  # メタデータ設定
  #-------------------------------------------------------------

  # metadata_configuration (Required)
  # 設定内容: S3バケットのメタデータ設定を指定します。
  # インベントリテーブルとジャーナルテーブルの両方が必須です。
  metadata_configuration {

    #-----------------------------------------------------------
    # インベントリテーブル設定
    #-----------------------------------------------------------

    # inventory_table_configuration (Required)
    # 設定内容: インベントリテーブルの設定を指定します。
    # インベントリテーブルはS3バケット内の全オブジェクトのメタデータを保持します。
    inventory_table_configuration {
      # configuration_state (Required)
      # 設定内容: インベントリテーブルの有効・無効状態を指定します。
      # 設定可能な値: "ENABLED", "DISABLED"
      configuration_state = "ENABLED"

      # encryption_configuration (Optional)
      # 設定内容: インベントリテーブルの暗号化設定を指定します。
      # 省略時: デフォルトの暗号化設定が使用される
      encryption_configuration {
        # sse_algorithm (Required)
        # 設定内容: メタデータテーブルの暗号化アルゴリズムを指定します。
        # 設定可能な値: "aws:kms", "AES256"
        sse_algorithm = "aws:kms"

        # kms_key_arn (Optional)
        # 設定内容: sse_algorithmが"aws:kms"の場合に使用するKMSキーのARNを指定します。
        # 設定可能な値: 有効なKMSキーのARN
        # 省略時: AWSマネージドKMSキーを使用
        kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/example-key-id"
      }
    }

    #-----------------------------------------------------------
    # ジャーナルテーブル設定
    #-----------------------------------------------------------

    # journal_table_configuration (Required)
    # 設定内容: ジャーナルテーブルの設定を指定します。
    # ジャーナルテーブルはS3バケット内のオブジェクト変更履歴を保持します。
    journal_table_configuration {
      # encryption_configuration (Optional)
      # 設定内容: ジャーナルテーブルの暗号化設定を指定します。
      # 省略時: デフォルトの暗号化設定が使用される
      encryption_configuration {
        # sse_algorithm (Required)
        # 設定内容: メタデータテーブルの暗号化アルゴリズムを指定します。
        # 設定可能な値: "aws:kms", "AES256"
        sse_algorithm = "aws:kms"

        # kms_key_arn (Optional)
        # 設定内容: sse_algorithmが"aws:kms"の場合に使用するKMSキーのARNを指定します。
        # 設定可能な値: 有効なKMSキーのARN
        # 省略時: AWSマネージドKMSキーを使用
        kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/example-key-id"
      }

      # record_expiration (Required)
      # 設定内容: ジャーナルテーブルのレコード有効期限設定を指定します。
      record_expiration {
        # expiration (Required)
        # 設定内容: ジャーナルテーブルのレコード有効期限を有効または無効にするかを指定します。
        # 設定可能な値: "ENABLED", "DISABLED"
        expiration = "ENABLED"

        # days (Optional)
        # 設定内容: ジャーナルテーブルのレコードを保持する日数を指定します。
        # 設定可能な値: 正の整数
        # 省略時: 保持日数の制限なし
        days = 7
      }
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 省略時: デフォルトのタイムアウト値が使用される
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" のような時間形式（s: 秒, m: 分, h: 時間）
    # 省略時: プロバイダーデフォルトのタイムアウト値
    create = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - metadata_configuration[0].destination[0].table_bucket_arn  : メタデータ設定が格納されるテーブルバケットのARN
# - metadata_configuration[0].destination[0].table_bucket_type : メタデータ設定が格納されるテーブルバケットのタイプ
# - metadata_configuration[0].destination[0].table_namespace   : メタデータテーブルが格納されるテーブルバケットの名前空間
# - metadata_configuration[0].inventory_table_configuration[0].table_arn  : インベントリテーブルのARN
# - metadata_configuration[0].inventory_table_configuration[0].table_name : インベントリテーブルの名前
# - metadata_configuration[0].journal_table_configuration[0].table_arn    : ジャーナルテーブルのARN
# - metadata_configuration[0].journal_table_configuration[0].table_name   : ジャーナルテーブルの名前
#
#---------------------------------------------------------------
