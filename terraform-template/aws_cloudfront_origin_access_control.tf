# ============================================================================
# Terraform AWS Resource Template: aws_cloudfront_origin_access_control
# ============================================================================
# Generated: 2026-01-18
# Provider Version: 6.28.0
#
# NOTE: このテンプレートは生成時点の AWS Provider 仕様に基づいています。
#       最新の仕様については公式ドキュメントを確認してください:
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control
# ============================================================================

# Amazon CloudFront Origin Access Control (OAC)
# CloudFront ディストリビューションで Amazon S3 バケットをオリジンとして使用する際に、
# アクセス制御を管理するリソース。OAC は従来の Origin Access Identity (OAI) の後継で、
# より多くの機能をサポートしています。
#
# AWS公式ドキュメント:
# - Origin Access Control概要: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html
# - API リファレンス: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_CreateOriginAccessControl.html
# - OAC設定詳細: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_OriginAccessControlConfig.html

resource "aws_cloudfront_origin_access_control" "example" {
  # ============================================================================
  # 必須パラメータ (Required)
  # ============================================================================

  # name - Origin Access Control の識別名
  # 型: string (required)
  #
  # Origin Access Control を識別するための名前。
  # 最大64文字まで設定可能。
  #
  # 参考: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_OriginAccessControlConfig.html
  name = "example-oac"

  # origin_access_control_origin_type - オリジンタイプ
  # 型: string (required)
  #
  # この Origin Access Control が対象とするオリジンのタイプを指定します。
  #
  # 設定可能な値:
  # - s3: Amazon S3 バケット (最も一般的)
  # - mediastore: AWS Elemental MediaStore
  # - mediapackagev2: AWS Elemental MediaPackage v2
  # - lambda: AWS Lambda 関数 URL
  #
  # 参考: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_OriginAccessControlConfig.html
  origin_access_control_origin_type = "s3"

  # signing_behavior - 署名動作
  # 型: string (required)
  #
  # CloudFront がどのリクエストに署名するかを指定します。
  #
  # 設定可能な値:
  # - always: CloudFront が常にオリジンへのリクエストに署名します (最も一般的な使用例)
  # - never: CloudFront はリクエストに署名しません
  # - no-override: CloudFront はビューアリクエストに Authorization ヘッダーが含まれていない場合のみ署名します
  #
  # 注意: "no-override" を使用する場合、Authorization ヘッダーをキャッシュポリシーに追加する必要があります。
  #
  # 参考: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_OriginAccessControlConfig.html
  signing_behavior = "always"

  # signing_protocol - 署名プロトコル
  # 型: string (required)
  #
  # CloudFront がリクエストを署名(認証)する方法を決定します。
  #
  # 設定可能な値:
  # - sigv4: AWS Signature Version 4 (現在唯一の有効な値)
  #
  # 参考: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_OriginAccessControlConfig.html
  signing_protocol = "sigv4"

  # ============================================================================
  # オプションパラメータ (Optional)
  # ============================================================================

  # description - 説明
  # 型: string (optional)
  #
  # Origin Access Control の説明。
  # 省略した場合、デフォルトで "Managed by Terraform" が設定されます。
  #
  # 参考: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_OriginAccessControlConfig.html
  description = "Example OAC for S3 bucket access control"

  # id - リソース識別子
  # 型: string (optional, computed)
  #
  # Origin Access Control の一意識別子。
  # 通常は Terraform が自動的に生成するため、明示的に設定する必要はありません。
  # 省略可能で、省略した場合は自動的に割り当てられます。
  #
  # 注意: この属性は通常設定せず、Terraform の自動割り当てに任せることを推奨します。
  # id = null  # コメントアウト推奨: Terraform による自動生成を使用

  # ============================================================================
  # Computed 属性 (Terraform が自動的に設定・参照可能)
  # ============================================================================
  # 以下の属性は Terraform によって自動的に設定されるため、このテンプレートには含まれません:
  #
  # - arn: Origin Access Control の ARN
  # - etag: Origin Access Control の現在のバージョン
  #
  # これらの値は他のリソースで参照可能です:
  # 例: aws_cloudfront_origin_access_control.example.arn
}

# ============================================================================
# 使用例とベストプラクティス
# ============================================================================
#
# 1. S3 バケットと CloudFront ディストリビューションの統合例:
#
# resource "aws_s3_bucket" "example" {
#   bucket = "my-cloudfront-bucket"
# }
#
# resource "aws_s3_bucket_policy" "example" {
#   bucket = aws_s3_bucket.example.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Sid    = "AllowCloudFrontServicePrincipal"
#       Effect = "Allow"
#       Principal = {
#         Service = "cloudfront.amazonaws.com"
#       }
#       Action   = "s3:GetObject"
#       Resource = "${aws_s3_bucket.example.arn}/*"
#       Condition = {
#         StringEquals = {
#           "AWS:SourceArn" = aws_cloudfront_distribution.example.arn
#         }
#       }
#     }]
#   })
# }
#
# resource "aws_cloudfront_distribution" "example" {
#   origin {
#     domain_name              = aws_s3_bucket.example.bucket_regional_domain_name
#     origin_id                = "S3-example"
#     origin_access_control_id = aws_cloudfront_origin_access_control.example.id
#   }
#   # ... その他の設定 ...
# }
#
# 2. OAI から OAC への移行:
#    Origin Access Control (OAC) は Origin Access Identity (OAI) の後継です。
#    OAC は以下の追加機能をサポートします:
#    - すべての AWS リージョンの Amazon S3 バケット
#    - AWS KMS による Amazon S3 サーバー側暗号化
#    - Amazon S3 への動的リクエスト (PUT/DELETE)
#
# 参考:
# - S3 オリジンへのアクセス制限: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html
# - Lambda 関数 URL への制限: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-lambda.html
# - AWS オリジンへのアクセス制限全般: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-origin.html
