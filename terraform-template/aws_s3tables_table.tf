#---------------------------------------------------------------
# Amazon S3 Tables Table
#---------------------------------------------------------------
#
# Amazon S3 Tables のテーブルをプロビジョニングするリソースです。
# S3 Tables は Apache Iceberg 形式のテーブル型データを管理するための
# テーブルバケット配下のリソースです。テーブルはネームスペースのサブリソースとして
# 作成され、クエリエンジン（Athena, Redshift, Spark等）から参照できます。
# S3 が自動的にファイル圧縮・スナップショット管理等のメンテナンスを実施します。
#
# AWS公式ドキュメント:
#   - S3 Tables テーブル概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-tables.html
#   - S3 Tables テーブル作成: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-create.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3tables_table
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3tables_table" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: テーブルの名前を指定します。
  # 設定可能な値: 1〜255文字の文字列。小文字・数字・アンダースコアが使用可能で、
  #              先頭と末尾は小文字または数字でなければなりません。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-buckets-naming.html#naming-rules-table
  name = "example_table"

  # namespace (Required)
  # 設定内容: このテーブルが属するネームスペースの名前を指定します。
  # 設定可能な値: 1〜255文字の文字列。小文字・数字・アンダースコアが使用可能で、
  #              先頭と末尾は小文字または数字でなければなりません。
  namespace = "example_namespace"

  # table_bucket_arn (Required, Forces new resource)
  # 設定内容: このテーブルが属するテーブルバケットの ARN を指定します。
  # 設定可能な値: 有効な S3 テーブルバケットの ARN
  # 注意: このパラメータを変更するとリソースが再作成されます。
  table_bucket_arn = "arn:aws:s3tables:ap-northeast-1:123456789012:bucket/example-bucket"

  # format (Required)
  # 設定内容: テーブルのフォーマットを指定します。
  # 設定可能な値:
  #   - "ICEBERG": Apache Iceberg 形式（現時点で唯一サポートされるフォーマット）
  format = "ICEBERG"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # encryption_configuration (Optional)
  # 設定内容: テーブルの暗号化設定を指定するオブジェクトです。
  # 省略時: テーブルバケットのデフォルト暗号化設定が適用されます。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-tables.html
  encryption_configuration = {
    # sse_algorithm (Required)
    # 設定内容: 使用するサーバーサイド暗号化アルゴリズムを指定します。
    # 設定可能な値:
    #   - "aws:kms": AWS KMS マネージドキーを使用して暗号化
    #   - "AES256": S3 マネージドキー（SSE-S3）を使用して暗号化
    sse_algorithm = "aws:kms"

    # kms_key_arn (Optional)
    # 設定内容: "aws:kms" を指定した場合に使用する KMS キーの ARN を指定します。
    # 設定可能な値: 有効な AWS KMS キーの ARN
    # 省略時: AWS マネージドキー（aws/s3tables）が使用されます。
    kms_key_arn = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  #-------------------------------------------------------------
  # メンテナンス設定
  #-------------------------------------------------------------

  # maintenance_configuration (Optional)
  # 設定内容: テーブルのメンテナンス設定を指定するオブジェクトです。
  #          Iceberg コンパクション（ファイル圧縮）とスナップショット管理の設定を含みます。
  # 省略時: テーブルバケットのデフォルトメンテナンス設定が適用されます。
  maintenance_configuration = {
    # iceberg_compaction (Required)
    # 設定内容: Iceberg テーブルのコンパクション（ファイル圧縮）設定を指定するオブジェクトです。
    #          小さなデータファイルを大きなファイルに結合してクエリパフォーマンスを向上させます。
    iceberg_compaction = {
      # status (Required)
      # 設定内容: コンパクション設定を有効にするかを指定します。
      # 設定可能な値:
      #   - "enabled": コンパクションを有効化
      #   - "disabled": コンパクションを無効化
      status = "enabled"

      # settings (Required)
      # 設定内容: コンパクションの詳細設定を指定するオブジェクトです。
      settings = {
        # target_file_size_mb (Required)
        # 設定内容: コンパクション時のターゲットファイルサイズをMB単位で指定します。
        #          このサイズより小さいデータオブジェクトは他のオブジェクトと結合されます。
        # 設定可能な値: 64〜512 の整数
        target_file_size_mb = 512
      }
    }

    # iceberg_snapshot_management (Required)
    # 設定内容: Iceberg テーブルのスナップショット管理設定を指定するオブジェクトです。
    #          古いスナップショットの削除ポリシーを定義します。
    iceberg_snapshot_management = {
      # status (Required)
      # 設定内容: スナップショット管理を有効にするかを指定します。
      # 設定可能な値:
      #   - "enabled": スナップショット管理を有効化
      #   - "disabled": スナップショット管理を無効化
      status = "enabled"

      # settings (Required)
      # 設定内容: スナップショット管理の詳細設定を指定するオブジェクトです。
      settings = {
        # max_snapshot_age_hours (Required)
        # 設定内容: この時間（時間単位）より古いスナップショットを削除対象としてマークします。
        # 設定可能な値: 1 以上の整数
        max_snapshot_age_hours = 120

        # min_snapshots_to_keep (Required)
        # 設定内容: 保持するスナップショットの最低数を指定します。
        #          max_snapshot_age_hours を超えた場合でも、この数のスナップショットは保持されます。
        # 設定可能な値: 1 以上の整数
        min_snapshots_to_keep = 1
      }
    }
  }

  #-------------------------------------------------------------
  # メタデータ設定
  #-------------------------------------------------------------

  # metadata (Optional)
  # 設定内容: テーブルのメタデータ（スキーマ定義等）を指定するブロックです。
  #          現時点では Iceberg 形式のみサポートしています。
  # 省略時: スキーマなしでテーブルが作成されます。
  metadata {
    # iceberg (Optional)
    # 設定内容: Apache Iceberg テーブルのメタデータ設定を指定するブロックです。
    #          テーブルのスキーマ構造（カラム定義）を定義します。
    iceberg {
      # schema (Required)
      # 設定内容: Iceberg テーブルのスキーマ設定を指定するブロックです。
      schema {
        # field (Required)
        # 設定内容: スキーマのフィールド（カラム）を定義するブロックです。
        #          複数の field ブロックを記述することで、複数のカラムを定義できます。
        # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-create.html
        field {
          # name (Required)
          # 設定内容: フィールド（カラム）名を指定します。
          # 設定可能な値: 任意の文字列
          name = "id"

          # type (Required)
          # 設定内容: フィールドのデータ型を指定します。
          #          S3 Tables は Apache Iceberg のプリミティブ型をすべてサポートしています。
          # 設定可能な値:
          #   - "boolean": 真偽値
          #   - "int": 32ビット整数
          #   - "long": 64ビット整数
          #   - "float": 32ビット浮動小数点
          #   - "double": 64ビット浮動小数点
          #   - "decimal(precision,scale)": 固定精度の10進数（例: "decimal(10,2)"）
          #   - "date": 日付
          #   - "time": 時刻
          #   - "timestamp": タイムスタンプ（タイムゾーンなし）
          #   - "timestamptz": タイムスタンプ（タイムゾーン付き）
          #   - "string": 文字列
          #   - "uuid": UUID
          #   - "fixed(length)": 固定長バイナリ（例: "fixed(16)"）
          #   - "binary": 可変長バイナリ
          type = "long"

          # required (Optional)
          # 設定内容: このフィールドの値が各行で必須かどうかを指定します。
          # 設定可能な値:
          #   - true: このフィールドは必須（NOT NULL 相当）
          #   - false: このフィールドは任意（NULL 許容）
          # 省略時: false（NULL 許容）
          required = true
        }

        field {
          name     = "name"
          type     = "string"
          required = true
        }

        field {
          name     = "created_at"
          type     = "timestamp"
          required = false
        }
      }
    }
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理する AWS リージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンが使用されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-table"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: テーブルの Amazon Resource Name (ARN)
# - created_at: テーブルが作成された日時
# - created_by: テーブルを作成したアカウントの ID
# - metadata_location: テーブルメタデータの格納場所
# - modified_at: テーブルが最後に変更された日時
# - modified_by: テーブルを最後に変更したアカウントの ID
# - owner_account_id: テーブルを所有するアカウントの ID
# - tags_all: プロバイダーの default_tags 設定を含む全タグのマップ
# - type: テーブルのタイプ（"customer" または "aws"）
# - version_token: テーブルデータの現在バージョンを示す識別子
# - warehouse_location: テーブルデータを格納する S3 URI
#---------------------------------------------------------------
