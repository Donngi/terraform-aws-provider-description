################################################################################
# AWS CloudFront Trust Store Template
################################################################################
# Generated: 2026-01-18
# Provider Version: 6.28.0
#
# Note: このテンプレートは生成時点の情報です。
# 最新の仕様については公式ドキュメントを確認してください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_trust_store
################################################################################

resource "aws_cloudfront_trust_store" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # name - (Required) Trust Storeの名前
  # CloudFront Trust Storeを識別するための名前を指定します。
  # この値を変更すると、新しいリソースが強制的に作成されます。
  #
  # Type: string
  # AWS Docs: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_CreateTrustStore.html
  name = "example-trust-store"

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # tags - (Optional) Trust Storeに適用するタグのマップ
  # リソースの分類や管理を容易にするためのキー・バリューペアです。
  # プロバイダーレベルでdefault_tags設定ブロックが構成されている場合、
  # キーが一致するタグは、プロバイダーレベルで定義されたタグを上書きします。
  #
  # Type: map(string)
  # AWS Docs: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_CreateTrustStore.html
  tags = {
    Environment = "production"
    Project     = "example"
  }

  # ============================================================================
  # Nested Blocks
  # ============================================================================

  # ca_certificates_bundle_source - (Required) CA証明書バンドルのソース設定
  # Trust Storeに含めるCA証明書バンドルの場所を指定します。
  # CloudFrontは、相互TLS認証時にクライアント証明書を検証するために
  # このCA証明書を使用します。
  #
  # AWS Docs: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/trust-stores-certificate-management.html
  ca_certificates_bundle_source {

    # ca_certificates_bundle_s3_location - (Required) S3上のCA証明書バンドルの場所
    # CA証明書バンドルが保存されているS3オブジェクトの詳細を指定します。
    # 証明書はPEM形式である必要があります。
    ca_certificates_bundle_s3_location {

      # bucket - (Required) CA証明書バンドルを含むS3バケット名
      # CA証明書が格納されているS3バケットの名前を指定します。
      #
      # Type: string
      # AWS Docs: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_CaCertificatesBundleS3Location.html
      bucket = "example-bucket"

      # key - (Required) CA証明書バンドルのS3オブジェクトキー
      # S3バケット内のCA証明書ファイルのオブジェクトキー（パス）を指定します。
      #
      # Type: string
      # AWS Docs: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_CaCertificatesBundleS3Location.html
      key = "ca-certificates.pem"

      # region - (Required) S3バケットのAWSリージョン
      # CA証明書バンドルが保存されているS3バケットのリージョンを指定します。
      #
      # Type: string
      # AWS Docs: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_CaCertificatesBundleS3Location.html
      region = "us-east-1"

      # version - (Optional) CA証明書バンドルのS3オブジェクトバージョンID
      # S3バケットでバージョニングが有効な場合、特定のオブジェクトバージョンを
      # 指定できます。省略した場合は最新バージョンが使用されます。
      #
      # Type: string
      # AWS Docs: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_CaCertificatesBundleS3Location.html
      version = "abc123def456"
    }
  }

  # ============================================================================
  # Timeouts Block (Optional)
  # ============================================================================

  # timeouts - (Optional) リソース操作のタイムアウト設定
  # Terraform操作（作成、更新、削除）のタイムアウト時間を指定します。
  # 形式は "30s"、"2h45m" のような文字列で、"s"（秒）、"m"（分）、"h"（時間）の
  # 単位を使用できます。
  timeouts {
    # create - (Optional) リソース作成操作のタイムアウト時間
    # Type: string (duration)
    create = "30m"

    # update - (Optional) リソース更新操作のタイムアウト時間
    # Type: string (duration)
    update = "30m"

    # delete - (Optional) リソース削除操作のタイムアウト時間
    # Type: string (duration)
    delete = "30m"
  }
}

################################################################################
# Computed Attributes (Read-Only)
################################################################################
# 以下の属性は、Terraformによって自動的に計算され、参照可能です:
#
# - arn (string)
#   Trust StoreのARN (Amazon Resource Name)
#   例: output "trust_store_arn" { value = aws_cloudfront_trust_store.example.arn }
#
# - etag (string)
#   Trust StoreのETag
#   リソースのバージョンを識別するために使用されます
#
# - id (string)
#   Trust StoreのID
#   例: output "trust_store_id" { value = aws_cloudfront_trust_store.example.id }
#
# - number_of_ca_certificates (number)
#   Trust Storeに含まれるCA証明書の数
#   例: output "ca_cert_count" { value = aws_cloudfront_trust_store.example.number_of_ca_certificates }
#
# - tags_all (map(string))
#   リソースに割り当てられた全てのタグ（プロバイダーのdefault_tags設定ブロックから
#   継承されたタグを含む）
#
################################################################################

################################################################################
# 使用例とベストプラクティス
################################################################################
#
# 1. CA証明書のフォーマット:
#    - PEM形式である必要があります
#    - ルートCAおよび中間CA証明書を含めることができます
#    - 適切なフォーマット、コンテンツ境界、コメント、改行が必要です
#    参考: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/trust-stores-certificate-management.html
#
# 2. 相互TLS認証:
#    - Trust Storeを作成した後、CloudFrontディストリビューションに関連付けて
#      相互TLS認証を有効化できます
#    - クライアント証明書の検証に使用されます
#
# 3. アカウントレベルリソース:
#    - Trust Storeはアカウントレベルのリソースです
#    - 複数のディストリビューションで同じTrust Storeを使用できます
#
# 4. S3バケットのアクセス権限:
#    - CloudFrontがCA証明書バンドルにアクセスできるよう、
#      適切なバケットポリシーまたはIAMロールが必要です
#
################################################################################
