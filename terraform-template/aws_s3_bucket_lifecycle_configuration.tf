#---------------------------------------------------------------
# AWS S3 Bucket Lifecycle Configuration
#---------------------------------------------------------------
#
# S3バケットのライフサイクル設定リソースをプロビジョニングします。
# このリソースは、S3バケット内のオブジェクトの有効期限、
# ストレージクラスへの移行、不完全なマルチパートアップロードの
# 削除などのライフサイクルルールを管理します。
#
# 注意: このリソースはS3ディレクトリバケットでは使用できません。
#       バージョニング対応バケットでは非現行バージョンのルールも設定できます。
#
# AWS公式ドキュメント:
#   - S3ライフサイクル設定:
#     https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket_lifecycle_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Required)
  # 設定内容: ライフサイクル設定を適用するS3バケット名を指定します。
  # 設定可能な値: 既存のS3バケット名
  bucket = "example-bucket"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # expected_bucket_owner (Optional)
  # 設定内容: バケットを所有するAWSアカウントIDを指定します。
  #           指定したアカウントIDがバケットの所有者と一致しない場合はエラーになります。
  # 設定可能な値: AWSアカウントID（12桁の数字）
  # 省略時: 検証なし（バケット所有者の確認をスキップ）
  expected_bucket_owner = null

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # transition_default_minimum_object_size (Optional)
  # 設定内容: ライフサイクルルールによるトランジションの対象となる
  #           オブジェクトの最小サイズのデフォルト値を指定します。
  # 設定可能な値:
  #   - "all_storage_classes_128K": 全ストレージクラスで128KBを最小サイズとする
  #   - "varies_by_storage_class": ストレージクラスごとに異なる最小サイズを適用する
  # 省略時: varies_by_storage_class
  transition_default_minimum_object_size = null

  #-------------------------------------------------------------
  # ライフサイクルルール設定
  #-------------------------------------------------------------

  # rule (Required)
  # 設定内容: ライフサイクルルールを定義します。
  #           複数のruleブロックを指定することで複数ルールを管理できます。
  rule {
    # id (Required)
    # 設定内容: ライフサイクルルールを識別するユニークなIDを指定します。
    # 設定可能な値: 任意の文字列（最大255文字）
    id = "example-rule"

    # status (Required)
    # 設定内容: このライフサイクルルールの有効・無効を指定します。
    # 設定可能な値: "Enabled"（有効）, "Disabled"（無効）
    status = "Enabled"

    # prefix (Optional, Deprecated)
    # 設定内容: ルールを適用するオブジェクトのキー名プレフィックスを指定します。
    #           非推奨です。代わりにfilterブロック内のprefixを使用してください。
    # 設定可能な値: 任意の文字列
    # 省略時: filterブロックで指定
    # prefix = "logs/"

    #-----------------------------------------------------------------
    # フィルタ設定
    #-----------------------------------------------------------------

    # filter (Optional)
    # 設定内容: ライフサイクルルールを適用するオブジェクトの条件を指定します。
    #           最大1つのブロックを指定できます。
    # 省略時: バケット内の全オブジェクトにルールが適用されます
    filter {
      # prefix (Optional)
      # 設定内容: ルールを適用するオブジェクトのキー名プレフィックスを指定します。
      # 設定可能な値: 任意の文字列（例: "logs/", "images/"）
      # 省略時: プレフィックスによるフィルタリングなし
      prefix = "logs/"

      # object_size_greater_than (Optional)
      # 設定内容: ルールを適用するオブジェクトの最小サイズ（バイト）を指定します。
      # 設定可能な値: 0以上の整数（バイト単位）
      # 省略時: サイズによる下限フィルタリングなし
      object_size_greater_than = null

      # object_size_less_than (Optional)
      # 設定内容: ルールを適用するオブジェクトの最大サイズ（バイト）を指定します。
      # 設定可能な値: 1以上の整数（バイト単位）
      # 省略時: サイズによる上限フィルタリングなし
      object_size_less_than = null

      # tag (Optional)
      # 設定内容: ルールを適用するオブジェクトのタグ条件を単一タグで指定します。
      #           複数条件を組み合わせる場合はandブロックを使用してください。
      # 省略時: タグによるフィルタリングなし
      tag {
        # key (Required)
        # 設定内容: フィルタリング条件のタグキーを指定します。
        # 設定可能な値: 任意の文字列
        key = "environment"

        # value (Required)
        # 設定内容: フィルタリング条件のタグ値を指定します。
        # 設定可能な値: 任意の文字列
        value = "production"
      }

      # and (Optional)
      # 設定内容: 複数のフィルタ条件（プレフィックス、タグ、サイズ）を
      #           AND条件で組み合わせる場合に使用します。
      # 省略時: 単一条件のフィルタリングを使用
      and {
        # prefix (Optional)
        # 設定内容: AND条件のプレフィックスを指定します。
        # 設定可能な値: 任意の文字列
        # 省略時: プレフィックスによるフィルタリングなし
        prefix = null

        # object_size_greater_than (Optional)
        # 設定内容: AND条件のオブジェクト最小サイズ（バイト）を指定します。
        # 設定可能な値: 0以上の整数（バイト単位）
        # 省略時: サイズによる下限フィルタリングなし
        object_size_greater_than = null

        # object_size_less_than (Optional)
        # 設定内容: AND条件のオブジェクト最大サイズ（バイト）を指定します。
        # 設定可能な値: 1以上の整数（バイト単位）
        # 省略時: サイズによる上限フィルタリングなし
        object_size_less_than = null

        # tags (Optional)
        # 設定内容: AND条件のタグセットをマップ形式で指定します。
        # 設定可能な値: キーと値のペアのマップ
        # 省略時: タグによるフィルタリングなし
        tags = {
          environment = "production"
          department  = "engineering"
        }
      }
    }

    #-----------------------------------------------------------------
    # オブジェクト期限切れ設定
    #-----------------------------------------------------------------

    # expiration (Optional)
    # 設定内容: オブジェクトの有効期限設定を指定します。
    #           date または days のいずれか一方を指定します。
    # 省略時: オブジェクトの自動削除なし
    expiration {
      # date (Optional)
      # 設定内容: オブジェクトを削除する日付をISO 8601形式で指定します。
      # 設定可能な値: ISO 8601形式の日付文字列（例: "2025-12-31T00:00:00Z"）
      # 省略時: 日付による期限切れなし
      date = null

      # days (Optional)
      # 設定内容: オブジェクト作成からの経過日数でオブジェクトを削除します。
      # 設定可能な値: 1以上の整数
      # 省略時: 日数による期限切れなし
      days = 365

      # expired_object_delete_marker (Optional)
      # 設定内容: バージョニングが有効なバケットで、
      #           非現行バージョンが存在しない削除マーカーを自動削除するかどうかを指定します。
      # 設定可能な値: true（自動削除する）, false（自動削除しない）
      # 省略時: false
      expired_object_delete_marker = null
    }

    #-----------------------------------------------------------------
    # 非現行バージョン期限切れ設定
    #-----------------------------------------------------------------

    # noncurrent_version_expiration (Optional)
    # 設定内容: バージョニングが有効なバケットで非現行バージョンの
    #           有効期限設定を指定します。
    # 省略時: 非現行バージョンの自動削除なし
    noncurrent_version_expiration {
      # noncurrent_days (Required)
      # 設定内容: オブジェクトが非現行バージョンになってから削除されるまでの日数を指定します。
      # 設定可能な値: 1以上の整数
      noncurrent_days = 90

      # newer_noncurrent_versions (Optional)
      # 設定内容: 保持する非現行バージョンの数を指定します。
      #           指定した数を超えた古い非現行バージョンが削除されます。
      # 設定可能な値: 1以上の整数
      # 省略時: バージョン数による制限なし
      newer_noncurrent_versions = null
    }

    #-----------------------------------------------------------------
    # ストレージクラス移行設定
    #-----------------------------------------------------------------

    # transition (Optional)
    # 設定内容: オブジェクトを別のストレージクラスへ移行する設定を指定します。
    #           複数のtransitionブロックを指定することで段階的な移行を設定できます。
    # 省略時: ストレージクラスの自動移行なし
    transition {
      # storage_class (Required)
      # 設定内容: 移行先のストレージクラスを指定します。
      # 設定可能な値:
      #   - "GLACIER": S3 Glacier Flexible Retrieval
      #   - "STANDARD_IA": S3 Standard-IA
      #   - "ONEZONE_IA": S3 One Zone-IA
      #   - "INTELLIGENT_TIERING": S3 Intelligent-Tiering
      #   - "DEEP_ARCHIVE": S3 Glacier Deep Archive
      #   - "GLACIER_IR": S3 Glacier Instant Retrieval
      storage_class = "STANDARD_IA"

      # days (Optional)
      # 設定内容: オブジェクト作成からの経過日数でストレージクラスを移行します。
      # 設定可能な値: 0以上の整数
      # 省略時: 日数による移行トリガーなし
      days = 30

      # date (Optional)
      # 設定内容: ストレージクラス移行を実行する日付をISO 8601形式で指定します。
      # 設定可能な値: ISO 8601形式の日付文字列（例: "2025-06-01T00:00:00Z"）
      # 省略時: 日付による移行トリガーなし
      date = null
    }

    #-----------------------------------------------------------------
    # 非現行バージョンストレージクラス移行設定
    #-----------------------------------------------------------------

    # noncurrent_version_transition (Optional)
    # 設定内容: バージョニングが有効なバケットで非現行バージョンの
    #           ストレージクラス移行設定を指定します。
    # 省略時: 非現行バージョンのストレージクラス自動移行なし
    noncurrent_version_transition {
      # storage_class (Required)
      # 設定内容: 非現行バージョンの移行先ストレージクラスを指定します。
      # 設定可能な値:
      #   - "GLACIER": S3 Glacier Flexible Retrieval
      #   - "STANDARD_IA": S3 Standard-IA
      #   - "ONEZONE_IA": S3 One Zone-IA
      #   - "INTELLIGENT_TIERING": S3 Intelligent-Tiering
      #   - "DEEP_ARCHIVE": S3 Glacier Deep Archive
      #   - "GLACIER_IR": S3 Glacier Instant Retrieval
      storage_class = "GLACIER"

      # noncurrent_days (Required)
      # 設定内容: オブジェクトが非現行バージョンになってから
      #           移行されるまでの日数を指定します。
      # 設定可能な値: 1以上の整数
      noncurrent_days = 30

      # newer_noncurrent_versions (Optional)
      # 設定内容: 保持する非現行バージョンの数を指定します。
      #           指定した数を超えた古い非現行バージョンが移行されます。
      # 設定可能な値: 1以上の整数
      # 省略時: バージョン数による制限なし
      newer_noncurrent_versions = null
    }

    #-----------------------------------------------------------------
    # 不完全なマルチパートアップロード設定
    #-----------------------------------------------------------------

    # abort_incomplete_multipart_upload (Optional)
    # 設定内容: 不完全なマルチパートアップロードを自動的に削除する設定を指定します。
    # 省略時: 不完全なマルチパートアップロードの自動削除なし
    abort_incomplete_multipart_upload {
      # days_after_initiation (Optional)
      # 設定内容: マルチパートアップロード開始からの経過日数で
      #           不完全なアップロードを削除するまでの日数を指定します。
      # 設定可能な値: 1以上の整数
      # 省略時: 日数による削除トリガーなし
      days_after_initiation = 7
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 省略時: デフォルトのタイムアウト値を使用
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "2h"）
    # 省略時: プロバイダーデフォルト値を使用
    create = null

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "2h"）
    # 省略時: プロバイダーデフォルト値を使用
    update = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: バケット名（バケット名とexpected_bucket_ownerの組み合わせの場合あり）
#
#---------------------------------------------------------------
