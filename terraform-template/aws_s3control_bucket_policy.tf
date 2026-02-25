#---------------------------------------------------------------
# AWS S3 Control Bucket Policy (S3 on Outposts)
#---------------------------------------------------------------
#
# S3 on Outpostsバケットのリソースポリシーをプロビジョニングするリソースです。
# このリソースはAWS Outposts上のS3バケットに対するアクセス制御ポリシーを管理します。
# AWS Partitionの通常S3バケットポリシーを管理する場合は aws_s3_bucket_policy を
# 使用してください。
#
# AWS公式ドキュメント:
#   - S3 on Outposts概要: https://docs.aws.amazon.com/AmazonS3/latest/dev/S3onOutposts.html
#   - S3 on Outpostsバケットポリシー: https://docs.aws.amazon.com/AmazonS3/latest/userguide/outposts-policies.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_bucket_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# NOTE: aws_s3control_bucket リソースのインラインポリシーと本リソースを
#       同時に使用しないでください。ポリシーの競合が発生します。
#
#---------------------------------------------------------------

resource "aws_s3control_bucket_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Required)
  # 設定内容: ポリシーを関連付けるS3 on OutpostsバケットのARNを指定します。
  # 設定可能な値: 有効なS3 on OutpostsバケットARN
  #   例: "arn:aws:s3-outposts:ap-northeast-1:123456789012:outpost/op-01234567890abcdef/bucket/my-bucket"
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/dev/S3onOutposts.html
  bucket = "arn:aws:s3-outposts:ap-northeast-1:123456789012:outpost/op-01234567890abcdef/bucket/my-bucket"

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: バケットに適用するリソースポリシーをJSON形式で指定します。
  # 設定可能な値: IAMポリシードキュメント（JSON文字列）
  # 関連機能: S3 on Outpostsバケットポリシー
  #   バケットポリシーは s3-outposts アクションを使用してアクセス制御を定義します。
  #   jsonencode()を使用してポリシードキュメントを記述することを推奨します。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/outposts-policies.html
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "testBucketPolicy"
    Statement = [
      {
        Sid    = "statement1"
        Effect = "Deny"
        Principal = {
          AWS = "*"
        }
        Action   = "s3-outposts:PutBucketLifecycleConfiguration"
        Resource = "arn:aws:s3-outposts:ap-northeast-1:123456789012:outpost/op-01234567890abcdef/bucket/my-bucket"
      }
    ]
  })

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: S3 on OutpostsバケットのARN。
#---------------------------------------------------------------
