#---------------------------------------------------------------
# AWS S3 Bucket Metrics Configuration
#---------------------------------------------------------------
#
# S3バケットのメトリクス設定リソースをプロビジョニングします。
# このリソースは、S3バケットのメトリクス設定を管理し、バケット全体または
# フィルタリングされた特定のオブジェクトに対してリクエストメトリクスを
# 有効化します。これにより、CloudWatchでバケットまたはプレフィックス/タグで
# フィルタリングされたオブジェクトのメトリクスを監視できます。
#
# 注意: このリソースはS3ディレクトリバケットでは使用できません。
#
# AWS公式ドキュメント:
#   - S3メトリクス設定概要: http://docs.aws.amazon.com/AmazonS3/latest/dev/metrics-configurations.html
#   - CloudWatch S3メトリクス: https://docs.aws.amazon.com/AmazonS3/latest/userguide/cloudwatch-monitoring.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_metric
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket_metric" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Required)
  # 設定内容: メトリクス設定を配置するバケットの名前を指定します。
  # 設定可能な値: 既存のS3バケット名
  # 注意: リソース作成後の変更はできません（Forces new resource）
  bucket = "example-bucket"

  # name (Required)
  # 設定内容: バケットのメトリクス設定の一意の識別子を指定します。
  # 設定可能な値: 64文字以下の文字列
  # 注意: リソース作成後の変更はできません（Forces new resource）
  name = "EntireBucket"

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
  # フィルタ設定
  #-------------------------------------------------------------

  # filter (Optional)
  # 設定内容: メトリクス設定に適用するオブジェクトフィルタリング条件を指定します。
  # 設定可能な値: prefix、tags、またはprefixとtagsの論理ANDの組み合わせ
  # 注意: filterブロック指定時は、access_point、prefix、tagsのいずれか1つ以上が必須です
  # 参考: http://docs.aws.amazon.com/AmazonS3/latest/dev/metrics-configurations.html#metrics-configurations-filter
  filter {
    # access_point (Optional)
    # 設定内容: フィルタリングに使用するS3アクセスポイントのARNを指定します。
    # 設定可能な値: S3アクセスポイントのARN
    # 注意: 単一のアクセスポイントのみ指定可能です
    # 用途: 特定のアクセスポイント経由でアクセスされるオブジェクトのみをメトリクス対象にする場合に使用
    # access_point = "arn:aws:s3:us-east-1:123456789012:accesspoint/example-access-point"

    # prefix (Optional)
    # 設定内容: フィルタリングに使用するオブジェクトプレフィックスを指定します。
    # 設定可能な値: 任意の文字列（パス形式も可）
    # 注意: 単一のプレフィックスのみ指定可能です
    # 用途: 特定のプレフィックス（ディレクトリパスなど）配下のオブジェクトのみをメトリクス対象にする場合に使用
    prefix = "documents/"

    # tags (Optional)
    # 設定内容: フィルタリングに使用するオブジェクトタグを指定します。
    # 設定可能な値: キーと値のペアのマップ（最大10個まで）
    # 用途: 特定のタグを持つオブジェクトのみをメトリクス対象にする場合に使用
    # 注意: prefixと組み合わせることで、論理AND条件でのフィルタリングが可能です
    tags = {
      priority = "high"
      class    = "blue"
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: バケット名とメトリクス設定名の組み合わせ（bucket:name）
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 1. バケット全体のメトリクス設定
#    filter ブロックを省略することで、バケット全体のメトリクスを収集します。
#
# resource "aws_s3_bucket_metric" "entire_bucket" {
#   bucket = aws_s3_bucket.example.id
#   name   = "EntireBucket"
# }
#
# 2. プレフィックスとタグでフィルタリング
#    特定のディレクトリ配下かつ特定のタグを持つオブジェクトのみを対象とします。
#
# resource "aws_s3_bucket_metric" "filtered" {
#   bucket = aws_s3_bucket.example.id
#   name   = "ImportantBlueDocuments"
#
#---------------------------------------------------------------
