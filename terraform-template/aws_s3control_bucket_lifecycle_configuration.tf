#---------------------------------------------------------------
# AWS S3 Control Bucket Lifecycle Configuration
#---------------------------------------------------------------
#
# S3 on Outpostsバケットのライフサイクル設定を管理するリソースです。
# このリソースは、S3 on Outpostsバケット内のオブジェクトのライフサイクルを
# 自動的に管理するためのルールを定義します。
#
# 重要な注意事項:
#   - 各S3 Controlバケットは1つのライフサイクル設定のみ持つことができます
#   - 同じバケットに対して複数のこのリソースを使用すると、Terraform実行ごとに差分が発生します
#   - このリソースはS3 on Outposts専用です
#   - 通常のS3バケットのライフサイクル設定には aws_s3_bucket_lifecycle_configuration を使用してください
#
# AWS公式ドキュメント:
#   - S3 on Outposts: https://docs.aws.amazon.com/AmazonS3/latest/dev/S3onOutposts.html
#   - ライフサイクル設定の設定: https://docs.aws.amazon.com/AmazonS3/latest/userguide/how-to-set-lifecycle-configuration-intro.html
#   - ライフサイクル設定要素: https://docs.aws.amazon.com/AmazonS3/latest/userguide/intro-lifecycle-rules.html
#   - PutBucketLifecycleConfiguration API: https://docs.aws.amazon.com/AmazonS3/latest/API/API_PutBucketLifecycleConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/s3control_bucket_lifecycle_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3control_bucket_lifecycle_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Required)
  # 設定内容: ライフサイクル設定を適用するS3 Control BucketのARNを指定します。
  # 設定可能な値: S3 Control BucketのARN (Amazon Resource Name)
  # 必須: はい
  # 関連リソース: aws_s3control_bucket
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/S3onOutposts.html
  bucket = aws_s3control_bucket.example.arn

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ライフサイクルルール設定
  #-------------------------------------------------------------

  # rule (Required)
  # 設定内容: バケットのライフサイクルルールを定義します。
  # 必須: はい（少なくとも1つ以上のルールが必要）
  # 注意: 複数のルールを定義でき、各ルールは異なるフィルタと動作を持つことができます
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/intro-lifecycle-rules.html

  # ログファイル用のライフサイクルルール
  rule {
    # id (Required)
    # 設定内容: ルールの一意の識別子を指定します。
    # 設定可能な値: 文字列（最大255文字）
    # 必須: はい
    # 注意: バケット内で一意である必要があります
    id = "logs-rule"

    # status (Optional)
    # 設定内容: ルールの有効/無効状態を指定します。
    # 設定可能な値:
    #   - "Enabled": ルールを有効化
    #   - "Disabled": ルールを無効化
    # 省略時: "Enabled"（有効）
    status = "Enabled"

    # filter (Optional)
    # 設定内容: ルールを適用するオブジェクトをフィルタリングします。
    # 省略時: バケット内の全てのオブジェクトに適用
    filter {
      # prefix (Optional)
      # 設定内容: オブジェクトキーのプレフィックスでフィルタリングします。
      # 設定可能な値: 文字列（オブジェクトキーのプレフィックス）
      # 例: "logs/" は "logs/" で始まる全てのオブジェクトにマッチ
      prefix = "logs/"

      # tags (Optional)
      # 設定内容: オブジェクトタグでフィルタリングします。
      # 設定可能な値: キーと値のペアのマップ
      # 注意: prefix と tags は同時に使用できます（AND条件）
      # tags = {
      #   Archive = "true"
      # }
    }

    # expiration (Optional)
    # 設定内容: オブジェクトの有効期限設定を定義します。
    # 注意: date、days、expired_object_delete_marker のいずれかを指定
    expiration {
      # days (Optional)
      # 設定内容: オブジェクト作成から削除までの日数を指定します。
      # 設定可能な値: 正の整数
      # 注意: date と排他的（どちらか一方のみ指定可能）
      # 計算方法: S3はオブジェクト作成時刻に指定日数を加算し、翌日午前0時(UTC)に切り上げて計算
      # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/intro-lifecycle-rules.html
      days = 365

      # date (Optional)
      # 設定内容: オブジェクトを削除する特定の日付を指定します。
      # 設定可能な値: YYYY-MM-DD形式の日付文字列（例: "2025-12-31"）
      # 注意: days と排他的（どちらか一方のみ指定可能）
      # date = "2025-12-31"

      # expired_object_delete_marker (Optional)
      # 設定内容: 非現行バージョンを持たない削除マーカーを削除するかを指定します。
      # 設定可能な値:
      #   - true: 期限切れオブジェクト削除マーカーを削除
      #   - false: 削除しない
      # 注意: date、days とは同時に指定できません
      # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/intro-lifecycle-rules.html
      # expired_object_delete_marker = false
    }

    # abort_incomplete_multipart_upload (Optional)
    # 設定内容: 不完全なマルチパートアップロードを中止する設定を定義します。
    # 関連機能: マルチパートアップロード
    #   大きなオブジェクトを複数のパートに分割してアップロードする機能です。
    #   不完全なアップロードはストレージコストが発生するため、定期的にクリーンアップが推奨されます。
    #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/intro-lifecycle-rules.html
    # abort_incomplete_multipart_upload {
    #   # days_after_initiation (Required)
    #   # 設定内容: マルチパートアップロード開始後、中止するまでの日数を指定します。
    #   # 設定可能な値: 正の整数
    #   # 必須: はい（abort_incomplete_multipart_upload ブロック内で）
    #   days_after_initiation = 7
    # }
  }

  # 一時ファイル用のライフサイクルルール
  rule {
    id     = "temp-files-rule"
    status = "Enabled"

    filter {
      prefix = "temp/"
    }

    expiration {
      days = 7
    }
  }

  # アーカイブ用のライフサイクルルール（タグベースのフィルタリング）
  # rule {
  #   id     = "archive-rule"
  #   status = "Enabled"
  #
  #   filter {
  #     tags = {
  #       Archive = "true"
  #       Type    = "backup"
  #     }
  #   }
  #
  #   expiration {
  #     days = 2555  # 約7年
  #   }
  #
  #   abort_incomplete_multipart_upload {
  #     days_after_initiation = 7
  #   }
  # }

  # 特定日付での削除ルール
  # rule {
  #   id     = "scheduled-deletion"
  #   status = "Enabled"
  #
  #   filter {
  #     prefix = "temporary-project/"
  #   }
  #
  #   expiration {
  #     date = "2026-12-31"
  #   }
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: S3 Control Bucketの Amazon Resource Name (ARN)
#       フォーマット: arn:aws:s3-outposts:{region}:{account-id}:outpost/{outpost-id}/bucket/{bucket-name}
#---------------------------------------------------------------

#---------------------------------------------------------------
# ライフサイクル設定のベストプラクティス
#---------------------------------------------------------------
# 1. ルールの優先順位
#    - 複数のルールが同じオブジェクトに適用される場合、より早く有効期限が切れるルールが優先されます
#    - ルールの競合を避けるため、フィルタを適切に設定してください
#
# 2. コスト最適化
#    - 不要なオブジェクトは定期的に削除することでストレージコストを削減できます
#    - 不完全なマルチパートアップロードは余分なコストが発生するため、定期的にクリーンアップしてください
#
# 3. タグベースのフィルタリング
#    - プレフィックスとタグを組み合わせることで、より細かい制御が可能です
#    - タグはオブジェクトのライフサイクル管理を柔軟にします
#
# 4. テストと検証
#---------------------------------------------------------------
