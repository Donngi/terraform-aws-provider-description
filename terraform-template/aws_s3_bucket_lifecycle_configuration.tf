# ===============================================
# AWS S3 Bucket Lifecycle Configuration
# ===============================================
# S3バケットのライフサイクル設定を独立したリソースとして管理します。
# ライフサイクルルールを使用して、オブジェクトの保存期間、ストレージクラスの移行、
# 自動削除などを設定できます。
#
# 公式ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html
#
# 重要な注意事項:
# - S3バケットは単一のライフサイクル設定のみをサポートします
# - 同じバケットに複数のaws_s3_bucket_lifecycle_configurationリソースを
#   宣言すると、設定の永続的な差異が発生します
# - ライフサイクル設定の変更は、すべてのAWS S3システムに完全に伝播するまで
#   時間がかかる場合があります
# ===============================================

resource "aws_s3_bucket_lifecycle_configuration" "example" {
  # -----------------------------------------------
  # 必須パラメータ
  # -----------------------------------------------

  # バケット名
  # Amazon S3が監視するソースS3バケットの名前を指定します。
  # 通常は aws_s3_bucket リソースの id 属性を参照します。
  bucket = "your-bucket-name" # 例: aws_s3_bucket.example.id

  # -----------------------------------------------
  # オプションパラメータ
  # -----------------------------------------------

  # バケット所有者のアカウントID
  # バケットが別のアカウントによって所有されている場合、
  # リクエストは HTTP 403 (Access Denied) エラーで失敗します。
  # expected_bucket_owner = "123456789012"

  # デフォルトの最小オブジェクトサイズ動作
  # ライフサイクル設定に適用されるデフォルトの最小オブジェクトサイズ動作。
  # 有効な値:
  # - all_storage_classes_128K (デフォルト): すべてのストレージクラスで128KB
  # - varies_by_storage_class: ストレージクラスによって異なる
  # カスタムの最小オブジェクトサイズを設定するには、
  # filter内で object_size_greater_than または object_size_less_than を指定します。
  # transition_default_minimum_object_size = "all_storage_classes_128K"

  # AWS リージョン
  # このリソースが管理されるリージョン。
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトで使用されます。
  # region = "ap-northeast-1"

  # -----------------------------------------------
  # ライフサイクルルール 1: ログファイルの管理
  # -----------------------------------------------
  # プレフィックス "logs/" のオブジェクトを管理します。
  # 30日後に STANDARD_IA に移行、60日後に GLACIER に移行、
  # 90日後に削除します。
  rule {
    # ルールの一意識別子
    # 最大255文字まで指定可能です。
    id = "log-management"

    # ルールの状態
    # 有効な値: Enabled または Disabled
    status = "Enabled"

    # -----------------------------------------------
    # フィルター: ルールが適用されるオブジェクトを識別
    # -----------------------------------------------
    # プレフィックスとタグの両方を使用する複雑なフィルタリング例
    filter {
      and {
        # オブジェクトキーのプレフィックス
        prefix = "logs/"

        # オブジェクトタグ
        # ルールが適用されるためには、これらのタグすべてが
        # オブジェクトのタグセットに存在する必要があります。
        tags = {
          Environment = "production"
          Type        = "log"
          AutoClean   = "true"
        }

        # 最小オブジェクトサイズ（バイト単位）
        # ルールが適用される最小オブジェクトサイズを指定します。
        # 指定する場合、値は0以上である必要があります。
        # object_size_greater_than = 0

        # 最大オブジェクトサイズ（バイト単位）
        # ルールが適用される最大オブジェクトサイズを指定します。
        # 指定する場合、値は1以上である必要があります。
        # object_size_less_than = 1073741824 # 1GB
      }
    }

    # -----------------------------------------------
    # トランジション: ストレージクラスの移行
    # -----------------------------------------------
    # 30日後に STANDARD_IA ストレージクラスに移行
    transition {
      # 作成後の日数
      # オブジェクトが作成されてから指定されたストレージクラスに
      # 移行されるまでの日数。正の整数である必要があります。
      days = 30

      # ストレージクラス
      # 有効な値: GLACIER, STANDARD_IA, ONEZONE_IA,
      # INTELLIGENT_TIERING, DEEP_ARCHIVE, GLACIER_IR
      storage_class = "STANDARD_IA"

      # 移行日時（daysと競合）
      # オブジェクトが指定されたストレージクラスに移行される日付。
      # RFC3339 full-date形式（例: 2023-08-22）で指定します。
      # date = "2024-12-31"
    }

    # 60日後に GLACIER ストレージクラスに移行
    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    # -----------------------------------------------
    # 有効期限: オブジェクトの削除
    # -----------------------------------------------
    # 90日後にオブジェクトを削除
    expiration {
      # オブジェクトの有効期限（日数）
      # ルールの対象となるオブジェクトの有効期間（日数）。
      # ゼロ以外の正の整数である必要があります。
      days = 90

      # 削除日時（daysおよびexpired_object_delete_markerと競合）
      # オブジェクトが移動または削除される日付。
      # RFC3339 full-date形式（例: 2023-08-22）で指定します。
      # date = "2024-12-31"

      # 削除マーカーの期限切れ
      # Amazon S3が非現行バージョンのない削除マーカーを削除するかどうかを示します。
      # trueに設定すると削除マーカーが期限切れになり、
      # falseに設定するとポリシーは何もアクションを実行しません。
      # dateとdaysと競合します。
      # expired_object_delete_marker = false
    }

    # -----------------------------------------------
    # 未完了マルチパートアップロードの中止
    # -----------------------------------------------
    # マルチパートアップロードの開始後、指定された日数が経過すると
    # Amazon S3がすべてのパーツを完全に削除します。
    abort_incomplete_multipart_upload {
      # 開始後の日数
      days_after_initiation = 7
    }
  }

  # -----------------------------------------------
  # ライフサイクルルール 2: 一時ファイルの管理
  # -----------------------------------------------
  # プレフィックス "tmp/" のオブジェクトを特定の日付で削除します。
  rule {
    id     = "tmp-cleanup"
    status = "Enabled"

    # プレフィックスのみでフィルタリング
    filter {
      prefix = "tmp/"
    }

    # 特定の日付で削除
    expiration {
      date = "2025-12-31T00:00:00Z"
    }
  }

  # -----------------------------------------------
  # ライフサイクルルール 3: バージョン管理されたオブジェクト
  # -----------------------------------------------
  # バージョン管理が有効なバケットの非現行バージョンを管理します。
  rule {
    id     = "versioned-objects-management"
    status = "Enabled"

    # フィルター: プレフィックス "config/" のオブジェクト
    filter {
      prefix = "config/"
    }

    # -----------------------------------------------
    # 非現行バージョンのトランジション
    # -----------------------------------------------
    # 非現行バージョンのオブジェクトがストレージクラスに移行するタイミングを
    # 指定するトランジションルールのセット。
    noncurrent_version_transition {
      # 非現行日数
      # オブジェクトが非現行になってから、Amazon S3が関連付けられた
      # アクションを実行できるようになるまでの日数。
      noncurrent_days = 30

      # ストレージクラス
      # 有効な値: GLACIER, STANDARD_IA, ONEZONE_IA,
      # INTELLIGENT_TIERING, DEEP_ARCHIVE, GLACIER_IR
      storage_class = "STANDARD_IA"

      # 新しい非現行バージョンの数
      # Amazon S3が保持する非現行バージョンの数。
      # ゼロ以外の正の整数である必要があります。
      # newer_noncurrent_versions = 3
    }

    noncurrent_version_transition {
      noncurrent_days = 60
      storage_class   = "GLACIER"
    }

    # -----------------------------------------------
    # 非現行バージョンの有効期限
    # -----------------------------------------------
    # 非現行オブジェクトバージョンの有効期限を指定します。
    noncurrent_version_expiration {
      # 非現行日数
      # オブジェクトが非現行になってから、Amazon S3が関連付けられた
      # アクションを実行できるようになるまでの日数。正の整数である必要があります。
      noncurrent_days = 90

      # 新しい非現行バージョンの数
      # Amazon S3が保持する非現行バージョンの数。
      # ゼロ以外の正の整数である必要があります。
      # newer_noncurrent_versions = 3
    }
  }

  # -----------------------------------------------
  # ライフサイクルルール 4: タグベースのフィルタリング
  # -----------------------------------------------
  # 単一のタグに基づいてフィルタリングする例
  rule {
    id     = "archive-old-data"
    status = "Enabled"

    # 単一タグでフィルタリング
    filter {
      tag {
        key   = "Archive"
        value = "true"
      }
    }

    transition {
      days          = 180
      storage_class = "GLACIER"
    }
  }

  # -----------------------------------------------
  # ライフサイクルルール 5: オブジェクトサイズベースのフィルタリング
  # -----------------------------------------------
  # 小さいオブジェクトの移行を許可する例
  rule {
    id     = "small-objects-transition"
    status = "Enabled"

    # オブジェクトサイズでフィルタリング
    filter {
      # 1バイト以上のオブジェクトに適用
      object_size_greater_than = 1
    }

    transition {
      days          = 365
      storage_class = "GLACIER_IR"
    }
  }

  # -----------------------------------------------
  # ライフサイクルルール 6: サイズ範囲とプレフィックスの組み合わせ
  # -----------------------------------------------
  # オブジェクトサイズ範囲とプレフィックスに基づくフィルタリング例
  rule {
    id     = "medium-sized-archives"
    status = "Enabled"

    filter {
      and {
        prefix                   = "archives/"
        object_size_greater_than = 500         # 500バイト以上
        object_size_less_than    = 64000       # 64KBまで
      }
    }

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }
  }

  # -----------------------------------------------
  # ライフサイクルルール 7: 空のフィルター（すべてのオブジェクト）
  # -----------------------------------------------
  # バケット内のすべてのオブジェクトに適用される例
  # rule {
  #   id     = "all-objects-cleanup"
  #   status = "Disabled"
  #
  #   # 空のフィルター（すべてのオブジェクトに適用）
  #   filter {}
  #
  #   expiration {
  #     days = 365
  #   }
  # }

  # -----------------------------------------------
  # 非推奨: prefix パラメータ（rule直下）
  # -----------------------------------------------
  # 注意: rule直下のprefixパラメータは非推奨です。
  # Amazon S3によって非推奨とされています。
  # 代わりに filter ブロックを使用してください。
  #
  # rule {
  #   id     = "deprecated-prefix-example"
  #   prefix = "old-way/"  # 非推奨
  #   status = "Enabled"
  #
  #   expiration {
  #     days = 30
  #   }
  # }
}

# ===============================================
# 出力値
# ===============================================

output "s3_bucket_lifecycle_configuration_id" {
  description = "バケット名、または expected_bucket_owner が指定されている場合はバケット名とそれをカンマ（,）で区切った値"
  value       = aws_s3_bucket_lifecycle_configuration.example.id
}

# ===============================================
# 使用例とベストプラクティス
# ===============================================

# 例1: バージョン管理されたバケットのライフサイクル設定
# バージョン管理を有効にした後、depends_onを使用して
# ライフサイクル設定を作成します。
#
# resource "aws_s3_bucket" "versioned" {
#   bucket = "my-versioned-bucket"
# }
#
# resource "aws_s3_bucket_versioning" "versioned" {
#   bucket = aws_s3_bucket.versioned.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }
#
# resource "aws_s3_bucket_lifecycle_configuration" "versioned" {
#   depends_on = [aws_s3_bucket_versioning.versioned]
#   bucket     = aws_s3_bucket.versioned.id
#
#   rule {
#     id     = "versioned-objects"
#     status = "Enabled"
#
#     filter {
#       prefix = "data/"
#     }
#
#     noncurrent_version_expiration {
#       noncurrent_days = 90
#     }
#
#     noncurrent_version_transition {
#       noncurrent_days = 30
#       storage_class   = "STANDARD_IA"
#     }
#   }
# }

# 例2: フィルターを使用しないルール
# フィルターもプレフィックスも指定しない場合、
# ルールはバケット内のすべてのオブジェクトに適用されます。
#
# resource "aws_s3_bucket_lifecycle_configuration" "no_filter" {
#   bucket = aws_s3_bucket.example.id
#
#   rule {
#     id     = "rule-1"
#     status = "Enabled"
#
#     expiration {
#       days = 365
#     }
#   }
# }

# 例3: 複数のストレージクラス移行
# オブジェクトを複数のストレージクラスを経て段階的に移行します。
#
# resource "aws_s3_bucket_lifecycle_configuration" "multi_tier" {
#   bucket = aws_s3_bucket.example.id
#
#   rule {
#     id     = "multi-tier-storage"
#     status = "Enabled"
#
#     filter {
#       prefix = "data/"
#     }
#
#     transition {
#       days          = 30
#       storage_class = "STANDARD_IA"
#     }
#
#     transition {
#       days          = 60
#       storage_class = "GLACIER_IR"
#     }
#
#     transition {
#       days          = 90
#       storage_class = "GLACIER"
#     }
#
#     transition {
#       days          = 180
#       storage_class = "DEEP_ARCHIVE"
#     }
#
#     expiration {
#       days = 365
#     }
#   }
# }

# ベストプラクティス:
# 1. バケットごとに1つのライフサイクル設定のみを使用する
# 2. ルールIDは説明的で一意なものにする
# 3. バージョン管理されたバケットでは depends_on を使用する
# 4. 非推奨の prefix パラメータの代わりに filter を使用する
# 5. ストレージクラスの移行順序を正しく設定する
#    （STANDARD → STANDARD_IA → GLACIER_IR → GLACIER → DEEP_ARCHIVE）
# 6. タグベースのフィルタリングを使用して柔軟な管理を行う
# 7. 未完了のマルチパートアップロードをクリーンアップする
# 8. テスト環境でルールを検証してから本番環境に適用する
