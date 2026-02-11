#---------------------------------------------------------------
# AWS S3 Bucket Metadata Configuration
#---------------------------------------------------------------
#
# S3バケットのメタデータ設定をプロビジョニングするリソースです。
# S3メタデータテーブルを使用することで、バケット内のオブジェクトのメタデータを
# 効率的に照会・分析できるようになります。インベントリテーブルとジャーナルテーブルの
# 2種類のメタデータテーブルを設定可能です。
#
# AWS公式ドキュメント:
#   - S3メタデータテーブル: https://docs.aws.amazon.com/AmazonS3/latest/userguide/metadata-tables-overview.html
#   - S3 Tables: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_metadata_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket_metadata_configuration" "example" {
  #-------------------------------------------------------------
  # バケット設定 (Required)
  #-------------------------------------------------------------

  # bucket (Required)
  # 設定内容: メタデータ設定を適用するS3バケットの名前を指定します。
  # 設定可能な値: 既存のS3バケット名またはARN
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingBucket.html
  bucket = "example-bucket-name"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # expected_bucket_owner (Optional)
  # 設定内容: バケットの所有者として期待されるAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: バケット所有者の検証は行われません
  # 用途: セキュリティ強化のため、想定外のアカウントのバケットへの操作を防ぎます
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-owner-condition.html
  expected_bucket_owner = null

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: AWSリージョン識別子（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定で指定されたリージョンが使用されます
  # Computed: 設定されていない場合は自動的に計算されます
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # メタデータ設定ブロック
  #-------------------------------------------------------------

  # metadata_configuration (Optional)
  # 設定内容: S3メタデータテーブルの設定を定義します。
  # 用途: バケット内のオブジェクトメタデータを効率的に照会・分析するための
  #       インベントリテーブルおよびジャーナルテーブルを設定します
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/metadata-tables-overview.html
  metadata_configuration {
    #-----------------------------------------------------------
    # インベントリテーブル設定
    #-----------------------------------------------------------

    # inventory_table_configuration (Optional)
    # 設定内容: S3インベントリテーブルの設定を定義します。
    # 用途: バケット内のすべてのオブジェクトのメタデータのスナップショットを
    #       定期的に作成し、効率的なクエリを可能にします
    # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/metadata-tables-inventory.html
    inventory_table_configuration {
      # configuration_state (Required)
      # 設定内容: インベントリテーブルの状態を指定します。
      # 設定可能な値:
      #   - "ENABLED": インベントリテーブルを有効化
      #   - "DISABLED": インベントリテーブルを無効化
      # 用途: メタデータテーブル機能の有効化/無効化を制御します
      configuration_state = "ENABLED"

      # encryption_configuration (Optional)
      # 設定内容: インベントリテーブルの暗号化設定を定義します。
      # 用途: 保存時のデータ暗号化を設定し、セキュリティを強化します
      encryption_configuration {
        # sse_algorithm (Required)
        # 設定内容: サーバーサイド暗号化アルゴリズムを指定します。
        # 設定可能な値:
        #   - "AES256": Amazon S3管理キーによるSSE-S3暗号化
        #   - "aws:kms": AWS KMS管理キーによるSSE-KMS暗号化
        # 推奨事項: セキュリティ要件に応じて適切な暗号化方式を選択してください
        # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/serv-side-encryption.html
        sse_algorithm = "AES256"

        # kms_key_arn (Optional)
        # 設定内容: AWS KMSキーのARNを指定します。
        # 設定可能な値: KMSキーのARN
        # 必須条件: sse_algorithm="aws:kms"の場合のみ指定可能
        # 省略時: AWS管理のKMSキー（aws/s3）が使用されます
        # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#key-id
        kms_key_arn = null
      }

      # table_arn (Computed)
      # 読み取り専用属性: 作成されたインベントリテーブルのARN
      # 用途: 他のリソースでこのテーブルを参照する際に使用します

      # table_name (Computed)
      # 読み取り専用属性: 作成されたインベントリテーブルの名前
      # 用途: テーブル名を取得して他の操作で使用します
    }

    #-----------------------------------------------------------
    # ジャーナルテーブル設定
    #-----------------------------------------------------------

    # journal_table_configuration (Optional)
    # 設定内容: S3ジャーナルテーブルの設定を定義します。
    # 用途: バケット内のオブジェクトに対する変更イベント（作成、削除、更新など）を
    #       リアルタイムで記録し、監査やコンプライアンスに活用します
    # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/metadata-tables-journal.html
    journal_table_configuration {
      # encryption_configuration (Optional)
      # 設定内容: ジャーナルテーブルの暗号化設定を定義します。
      # 用途: 保存時のデータ暗号化を設定し、セキュリティを強化します
      encryption_configuration {
        # sse_algorithm (Required)
        # 設定内容: サーバーサイド暗号化アルゴリズムを指定します。
        # 設定可能な値:
        #   - "AES256": Amazon S3管理キーによるSSE-S3暗号化
        #   - "aws:kms": AWS KMS管理キーによるSSE-KMS暗号化
        # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/serv-side-encryption.html
        sse_algorithm = "AES256"

        # kms_key_arn (Optional)
        # 設定内容: AWS KMSキーのARNを指定します。
        # 設定可能な値: KMSキーのARN
        # 必須条件: sse_algorithm="aws:kms"の場合のみ指定可能
        # 省略時: AWS管理のKMSキー（aws/s3）が使用されます
        kms_key_arn = null
      }

      # record_expiration (Optional)
      # 設定内容: ジャーナルレコードの有効期限設定を定義します。
      # 用途: 古いジャーナルレコードを自動的に削除し、ストレージコストを管理します
      record_expiration {
        # expiration (Required)
        # 設定内容: レコード有効期限のタイプを指定します。
        # 設定可能な値:
        #   - "DAYS": 日数ベースの有効期限
        #   - "NEVER": レコードを永続的に保持
        # 用途: 監査要件やコンプライアンス要件に応じて保持期間を設定します
        expiration = "DAYS"

        # days (Optional)
        # 設定内容: レコードを保持する日数を指定します。
        # 設定可能な値: 正の整数（日数）
        # 必須条件: expiration="DAYS"の場合に指定が必要
        # 省略時: expirationがNEVERの場合は不要
        # 推奨事項: 組織の保持ポリシーに従って適切な日数を設定してください
        days = 90
      }

      # table_arn (Computed)
      # 読み取り専用属性: 作成されたジャーナルテーブルのARN
      # 用途: 他のリソースでこのテーブルを参照する際に使用します

      # table_name (Computed)
      # 読み取り専用属性: 作成されたジャーナルテーブルの名前
      # 用途: テーブル名を取得して他の操作で使用します
    }

    # destination (Computed)
    # 読み取り専用属性: メタデータテーブルの保存先情報
    # 含まれる情報:
    #   - table_bucket_arn: テーブルバケットのARN
    #   - table_bucket_type: テーブルバケットのタイプ
    #   - table_namespace: テーブルのネームスペース
  }

  #-------------------------------------------------------------
  # タイムアウト設定 (Optional)
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 特定の操作のタイムアウト時間を設定します。
  # 用途: デフォルトのタイムアウト時間を変更する必要がある場合に使用します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    # 推奨事項: 大規模なバケットの場合は長めに設定することを推奨します
    create = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - destination: メタデータテーブルの保存先情報（Computed）
#     - table_bucket_arn: テーブルバケットのARN
#     - table_bucket_type: テーブルバケットのタイプ
#     - table_namespace: テーブルのネームスペース
#
# - inventory_table_configuration.table_arn: インベントリテーブルのARN（Computed）
# - inventory_table_configuration.table_name: インベントリテーブルの名前（Computed）
#
# - journal_table_configuration.table_arn: ジャーナルテーブルのARN（Computed）
# - journal_table_configuration.table_name: ジャーナルテーブルの名前（Computed）
#
# 用途例:
# - メタデータテーブルのARNを他のリソース（IAMポリシーなど）で参照
# - テーブル名を使用してクエリやアクセス制御を設定
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# 【基本的な使用例】
#
#---------------------------------------------------------------
