#######################################################################
# CloudFront Trust Store
#######################################################################
# CloudFrontのmutual TLS認証で使用するCA証明書バンドルのトラストストア
#
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudfront_trust_store
# Generated: 2026-02-12
#
# NOTE: 本テンプレートはTerraform AWS Provider v6.28.0のスキーマ定義に基づいて
#       自動生成されています。実際の利用時には、プロジェクト要件に応じて
#       適切にカスタマイズしてください。
#
# 【Trust Storeの概要】
# - クライアント証明書検証に使用するCA証明書のリポジトリ
# - ルート証明書および中間証明書を管理
# - 複数のディストリビューションで共有可能なアカウントレベルリソース
# - AWS Private CAまたはサードパーティCA証明書をサポート
#
# 【証明書要件】
# - PEM形式のCA証明書バンドルが必要
# - S3バケットに証明書バンドルを配置
# - 証明書のフォーマットおよび内容要件を満たす必要がある
#
# 【関連リソース】
# - aws_cloudfront_distribution: トラストストアをディストリビューションに関連付け
# - aws_s3_bucket: CA証明書バンドルの保存先
#
# 【ユースケース】
# - クライアント証明書認証が必要なAPI配信
# - セキュアなコンテンツ配信環境
# - エンタープライズ向けmTLS認証

#-----------------------------------------------------------------------
# Basic Configuration
#-----------------------------------------------------------------------

resource "aws_cloudfront_trust_store" "example" {
  # トラストストア名
  # 設定内容: トラストストアを識別する一意の名前
  # 必須項目
  name = "example-trust-store"

  #-----------------------------------------------------------------------
  # CA Certificates Bundle Configuration
  #-----------------------------------------------------------------------

  # CA証明書バンドルのソース設定
  ca_certificates_bundle_source {
    # S3に保存されたCA証明書バンドルの場所
    ca_certificates_bundle_s3_location {
      # 証明書バンドルを保存しているS3バケット名
      # 設定内容: CA証明書バンドルが格納されているS3バケット
      # 必須項目
      bucket = "example-ca-certificates-bucket"

      # 証明書バンドルのS3オブジェクトキー
      # 設定内容: バケット内のCA証明書バンドルファイルのパス
      # 必須項目
      key = "ca-certificates/bundle.pem"

      # S3バケットのリージョン
      # 設定内容: バケットが存在するAWSリージョン
      # 設定可能な値: 有効なAWSリージョン（例: us-east-1, ap-northeast-1）
      # 必須項目
      region = "us-east-1"

      # S3オブジェクトのバージョンID
      # 設定内容: バージョニング有効時の特定バージョンを指定
      # 省略時: 最新バージョンが使用される
      # version = "abc123"
    }
  }

  #-----------------------------------------------------------------------
  # Tagging
  #-----------------------------------------------------------------------

  # リソースタグ
  # 設定内容: トラストストアに付与するタグのキーバリューペア
  # 省略時: タグなし
  tags = {
    Environment = "production"
    Purpose     = "mtls-authentication"
    ManagedBy   = "terraform"
  }
}

#-----------------------------------------------------------------------
# Timeouts
#-----------------------------------------------------------------------

# resource "aws_cloudfront_trust_store" "example_with_timeouts" {
#   name = "example-trust-store"
#
#   ca_certificates_bundle_source {
#     ca_certificates_bundle_s3_location {
#       bucket = "example-ca-certificates-bucket"
#       key    = "ca-certificates/bundle.pem"
#       region = "us-east-1"
#     }
#   }
#
#   timeouts {
#     # 作成時のタイムアウト
#     # 設定内容: トラストストア作成処理の最大待機時間
#     # 設定可能な値: 期間文字列（例: "30s", "5m", "1h"）
#     # 省略時: デフォルトのタイムアウト値
#     # create = "30m"
#
#     # 更新時のタイムアウト
#     # 設定内容: トラストストア更新処理の最大待機時間
#     # 設定可能な値: 期間文字列（例: "30s", "5m", "1h"）
#     # 省略時: デフォルトのタイムアウト値
#     # update = "30m"
#
#     # 削除時のタイムアウト
#     # 設定内容: トラストストア削除処理の最大待機時間
#     # 設定可能な値: 期間文字列（例: "30s", "5m", "1h"）
#     # 省略時: デフォルトのタイムアウト値
#     # delete = "30m"
#   }
# }

#-----------------------------------------------------------------------
# Attributes Reference
#-----------------------------------------------------------------------
# 以下の属性がエクスポートされ、他のリソースから参照可能:
#
# - id: トラストストアID
# - arn: トラストストアのARN
# - etag: トラストストアのETag値（バージョン管理用）
# - number_of_ca_certificates: バンドルに含まれるCA証明書の数
# - tags_all: デフォルトタグを含む全てのタグ
#
# 参照例:
# resource "aws_cloudfront_distribution" "example" {
#   # トラストストアをディストリビューションに関連付け
#   trust_store_id = aws_cloudfront_trust_store.example.id
# }
