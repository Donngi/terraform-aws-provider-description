#---------------------------------------------------------------
# AWS S3 Vectors Vector Bucket
#---------------------------------------------------------------
#
# Amazon S3 Vectorsのベクターバケットをプロビジョニングするリソースです。
# ベクターバケットは、ベクターデータの保存とクエリに特化した新しいタイプの
# S3バケットで、大規模なベクターデータセットのコスト効率的かつ弾力的で
# 耐久性のあるストレージを提供します。
#
# AWS公式ドキュメント:
#   - S3 Vectors概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors.html
#   - ベクターバケットの作成: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors-buckets-create.html
#   - ベクターバケット: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors-buckets.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3vectors_vector_bucket
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3vectors_vector_bucket" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # vector_bucket_name (Required, Forces new resource)
  # 設定内容: ベクターバケットの名前を指定します。
  # 設定可能な値: ベクターバケット命名規則に準拠した文字列
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors-buckets.html
  # 注意: 作成後の変更は不可（Forces new resource）
  vector_bucket_name = "example-vector-bucket"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: S3 Vectors プレビューは us-east-1, us-east-2, us-west-2, eu-central-1, ap-southeast-2 で利用可能
  region = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # encryption_configuration (Optional, Forces new resource)
  # 設定内容: ベクターバケットのデフォルト暗号化設定を指定します。
  # 省略時: AES256（SSE-S3）による暗号化が自動的に適用されます
  # 関連機能: S3 Vectors 暗号化
  #   ベクターバケットは保存時にデフォルトで暗号化されます。
  #   SSE-S3（AES256）またはSSE-KMS（aws:kms）を選択可能。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors-buckets-create.html
  # 注意: 作成後の暗号化設定の変更は不可（Forces new resource）
  encryption_configuration = [
    {
      # sse_type (Optional, Forces new resource)
      # 設定内容: ベクターバケットのデフォルト暗号化に使用するサーバー側暗号化タイプを指定します。
      # 設定可能な値:
      #   - "AES256": SSE-S3（Amazon S3管理キー）による暗号化
      #   - "aws:kms": SSE-KMS（AWS KMS カスタマーマスターキー）による暗号化
      # 省略時: AES256が適用されます
      # 注意: 作成後の変更は不可（Forces new resource）
      sse_type = "aws:kms"

      # kms_key_arn (Optional, Forces new resource)
      # 設定内容: ベクターバケットのデフォルト暗号化に使用するAWS KMS CMKのARNを指定します。
      # 設定可能な値: 有効なKMSキーARN
      # 注意: sse_typeが"aws:kms"の場合のみ指定可能。sse_typeが"AES256"の場合は指定不可
      # 関連機能: AWS KMS による暗号化
      #   KMSキーを使用することで、暗号化キーとアクセスポリシーをより詳細に制御可能。
      #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors-buckets-create.html
      # 注意: 作成後の変更は不可（Forces new resource）
      kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
    }
  ]

  #-------------------------------------------------------------
  # 削除設定
  #-------------------------------------------------------------

  # force_destroy (Optional)
  # 設定内容: ベクターバケット削除時に、すべてのインデックスとベクターを自動削除するかを指定します。
  # 設定可能な値:
  #   - true: 削除時にベクターバケット内のすべてのインデックスとベクターを削除し、エラーなく削除を実行
  #   - false (デフォルト): ベクターバケットに内容が残っている場合、削除がエラーになります
  # 省略時: false
  # 注意: このパラメータをtrueに設定した後、destroyの前に必ず成功した terraform apply の実行が必要です。
  #       成功した terraform apply なしでは、このフラグは効果を持ちません。
  #       ベクターバケットの置き換えまたは削除が必要な操作と同時にこのフィールドを設定しても、
  #       このフラグは機能しません。
  force_destroy = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-vector-bucket"
    Environment = "production"
    Purpose     = "AI vector storage"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - creation_time: ベクターバケットが作成された日時
#
# - vector_bucket_arn: ベクターバケットのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
