#---------------------------------------------------------------
# Amazon S3 Vectors Index
#---------------------------------------------------------------
#
# Amazon S3 Vectors Indexをプロビジョニングするリソースです。
# ベクターインデックスは、ベクターバケット内のリソースとして、ベクターデータに対する
# 効率的な類似性検索操作を実現します。インデックス作成時には、距離メトリック、
# 次元数、データ型、オプションのメタデータ設定を指定します。
#
# 主な用途:
# - セマンティック検索やRAG（Retrieval-Augmented Generation）ワークフロー
# - 医療画像解析や画像重複排除
# - エンタープライズドキュメント検索
# - パーソナライゼーション
#
# AWS公式ドキュメント:
#   - Vector indexes: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors-indexes.html
#   - Creating a vector index: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors-create-index.html
#   - Working with S3 Vectors: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors.html
#   - Querying vectors: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors-query.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3vectors_index
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3vectors_index" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # index_name (Required, Forces new resource)
  # 設定内容: ベクターインデックスの名前を指定します。
  # 設定可能な値: 3〜63文字の文字列（小文字、数字、ハイフンのみ使用可能）
  # 注意: 先頭と末尾は英数字である必要があります。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors-indexes.html
  index_name = "example-index"

  # vector_bucket_name (Required, Forces new resource)
  # 設定内容: ベクターインデックスが属するベクターバケットの名前を指定します。
  # 設定可能な値: 既存のS3 Vectorsベクターバケットの名前
  # 注意: ベクターバケットは事前に作成されている必要があります。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors-create-index.html
  vector_bucket_name = "example-vector-bucket"

  #-------------------------------------------------------------
  # ベクター設定
  #-------------------------------------------------------------

  # data_type (Required, Forces new resource)
  # 設定内容: ベクターインデックスに挿入されるベクターのデータ型を指定します。
  # 設定可能な値:
  #   - float32: 32ビット浮動小数点数（現時点で唯一サポートされている型）
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors-indexes.html
  data_type = "float32"

  # dimension (Required, Forces new resource)
  # 設定内容: ベクターインデックスに挿入されるベクターの次元数を指定します。
  # 設定可能な値: 1〜4096の整数
  # 関連機能: ベクター次元
  #   ディメンションは、ベクター内の値の数を表します。クエリベクターの生成に使用する
  #   埋め込みモデルと同じ次元数を指定する必要があります。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors-indexes.html
  # 注意: ベクター埋め込みモデルの出力次元と一致させる必要があります。
  dimension = 1536

  # distance_metric (Required, Forces new resource)
  # 設定内容: 類似性検索に使用する距離メトリックを指定します。
  # 設定可能な値:
  #   - cosine: コサイン類似度（ベクターの方向が重要な場合に使用、テキスト埋め込みに推奨）
  #   - euclidean: ユークリッド距離（ベクターの大きさと方向の両方が重要な場合に使用）
  # 関連機能: 距離メトリック
  #   適切な距離メトリックを選択することで、検索精度とパフォーマンスを最適化できます。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors-indexes.html
  distance_metric = "cosine"

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
  # 暗号化設定
  #-------------------------------------------------------------

  # encryption_configuration (Optional, Forces new resource)
  # 設定内容: ベクターインデックスの暗号化設定を指定します。
  # 省略時: デフォルトでAES256暗号化が適用されます。
  # 関連機能: データ暗号化
  #   S3 Vectorsは保存時の暗号化をサポートしています。AWS管理キー（AES256）または
  #   カスタマー管理キー（KMS）を使用できます。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors-create-index.html
  encryption_configuration = {
    # sse_type (Optional, Forces new resource)
    # 設定内容: 暗号化タイプを指定します。
    # 設定可能な値:
    #   - AES256: Amazon S3管理の暗号化キー（デフォルト）
    #   - aws:kms: AWS KMS管理の暗号化キー
    # 省略時: AES256
    sse_type = "AES256"

    # kms_key_arn (Optional, Forces new resource)
    # 設定内容: AWS KMSカスタマー管理キーのARNを指定します。
    # 設定可能な値: 有効なKMSキーのARN形式
    # 注意: sse_typeが"aws:kms"の場合のみ指定可能です。
    # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors-create-index.html
    # kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  #-------------------------------------------------------------
  # メタデータ設定
  #-------------------------------------------------------------

  # metadata_configuration (Optional, Forces new resource)
  # 設定内容: ベクターインデックスのメタデータ設定を指定します。
  # 関連機能: メタデータフィルタリング
  #   フィルタリング不可のメタデータキーを指定することで、ベクターと一緒に
  #   追加のコンテキスト情報を保存できます。これらのキーは検索時に取得できますが、
  #   フィルタリングには使用できません。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors-indexes.html
  # metadata_configuration {
  #   # non_filterable_metadata_keys (Required, Forces new resource)
  #   # 設定内容: フィルタリング不可のメタデータキーのリストを指定します。
  #   # 設定可能な値: 文字列のセット
  #   # 用途: フィルタリングに使用しないメタデータを指定することで、
  #   #       インデックスサイズを最適化し、検索パフォーマンスを向上させることができます。
  #   # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors-create-index.html
  #   non_filterable_metadata_keys = ["source", "timestamp"]
  # }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors-create-index.html
  tags = {
    Name        = "example-vector-index"
    Environment = "production"
    Purpose     = "semantic-search"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - creation_time: ベクターインデックスが作成された日時
#                  例: "2024-01-15T10:30:00Z"
#
# - index_arn: ベクターインデックスのAmazon Resource Name (ARN)
#              例: "arn:aws:s3vectors:us-east-1:123456789012:index/example-index"
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
