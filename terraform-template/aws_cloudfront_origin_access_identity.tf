#================================================================================
# Terraform AWS Resource Template: aws_cloudfront_origin_access_identity
#================================================================================
# Generated: 2026-01-18
# Provider Version: 6.28.0
#
# NOTE: このテンプレートは生成時点(2026-01-18)の情報に基づいています。
#       最新の仕様については公式ドキュメントを必ず確認してください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity
#================================================================================

resource "aws_cloudfront_origin_access_identity" "example" {
  #------------------------------------------------------------------------------
  # Optional Arguments
  #------------------------------------------------------------------------------

  # comment - (Optional) コメント文字列
  # CloudFront Origin Access Identity (OAI) に関する説明を記述します。
  # OAIは、CloudFrontディストリビューションがS3バケットのコンテンツに
  # アクセスする際に使用する特別なCloudFrontユーザーです。
  #
  # NOTE: AWS は現在、Origin Access Identity (OAI) よりも
  #       Origin Access Control (OAC) の使用を推奨しています。
  #       OACは、すべてのAWSリージョンのS3バケット、AWS KMSによる
  #       サーバーサイド暗号化、動的リクエストなどをサポートしています。
  #
  # Type: string
  # AWS Doc: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html
  comment = "OAI for S3 bucket access restriction"

  # id - (Optional) Origin Access Identityの識別子
  # この属性は computed でもあるため、通常は指定する必要はありません。
  # CloudFrontが自動的に一意のIDを生成します。
  #
  # Type: string
  # id = null

  #------------------------------------------------------------------------------
  # Computed Attributes (Read-Only)
  #------------------------------------------------------------------------------
  # 以下の属性はTerraformによって自動的に計算され、参照可能です:
  #
  # arn - Origin Access IdentityのARN
  #   例: "arn:aws:cloudfront::123456789012:origin-access-identity/E2QWRUHAPOMQZL"
  #
  # caller_reference - CloudFrontが内部的に使用する値
  #   将来のアップデートを可能にするためにCloudFrontが使用する内部値
  #
  # cloudfront_access_identity_path - CloudFrontで使用するフルパスへのショートカット
  #   例: "origin-access-identity/cloudfront/E2QWRUHAPOMQZL"
  #
  # etag - Origin Access Identity情報の現在のバージョン
  #   例: "E2QWRUHAPOMQZL"
  #
  # iam_arn - S3バケットポリシーで使用する事前生成されたARN
  #   S3バケットポリシーでCloudFrontにアクセス権限を付与する際に使用します。
  #   例: "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E2QWRUHAPOMQZL"
  #
  # s3_canonical_user_id - Origin Access IdentityのAmazon S3正規ユーザーID
  #   S3でOrigin Access Identityにオブジェクトへの読み取り権限を付与する際に使用します。
  #------------------------------------------------------------------------------
}

#================================================================================
# 使用例: S3バケットポリシーとの統合
#================================================================================
# CloudFront OAIを使用してS3バケットへのアクセスを制限する例:
#
# resource "aws_s3_bucket" "example" {
#   bucket = "my-cloudfront-bucket"
# }
#
# resource "aws_s3_bucket_policy" "example" {
#   bucket = aws_s3_bucket.example.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "AllowCloudFrontOAI"
#         Effect = "Allow"
#         Principal = {
#           AWS = aws_cloudfront_origin_access_identity.example.iam_arn
#         }
#         Action   = "s3:GetObject"
#         Resource = "${aws_s3_bucket.example.arn}/*"
#       }
#     ]
#   })
# }
#
# resource "aws_cloudfront_distribution" "example" {
#   origin {
#     domain_name = aws_s3_bucket.example.bucket_regional_domain_name
#     origin_id   = "S3-${aws_s3_bucket.example.id}"
#
#     s3_origin_config {
#       origin_access_identity = aws_cloudfront_origin_access_identity.example.cloudfront_access_identity_path
#     }
#   }
#
#   # ... その他のCloudFrontディストリビューション設定 ...
# }
#================================================================================

#================================================================================
# 参考リンク
#================================================================================
# - Terraform AWS Provider Documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity
#
# - AWS CloudFront Developer Guide - Restricting Access to S3:
#   https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html
#
# - AWS CloudFront API Reference - S3Origin:
#   https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_S3Origin.html
#================================================================================
