#---------------------------------------------------------------
# AWS Elemental MediaStore Container
#---------------------------------------------------------------
#
# AWS Elemental MediaStoreのコンテナをプロビジョニングするリソースです。
# MediaStoreは、ライブストリーミングメディアワークフロー向けに最適化された
# AWSのメディアストレージサービスです。
#
# 警告: このリソースは非推奨（deprecated）です。
# AWSはAWS Elemental MediaStoreを2025年11月13日に廃止することを発表しました。
# シンプルなライブストリーミングワークフローにはAmazon S3への移行を推奨します。
# パッケージング・DRM・クロスリージョン冗長性等の高度なユースケースには
# AWS Elemental MediaPackageの使用を検討してください。
#
# AWS公式ドキュメント:
#   - MediaStore概要: https://docs.aws.amazon.com/mediastore/latest/ug/what-is.html
#   - MediaStore廃止アナウンス: https://aws.amazon.com/blogs/media/support-for-aws-elemental-mediastore-ending-soon/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/media_store_container
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_media_store_container" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: コンテナの名前を指定します。
  # 設定可能な値: 英数字またはアンダースコアを含む文字列
  name = "example"

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: コンテナのAmazon Resource Name (ARN)
#
# - endpoint: コンテナのDNSエンドポイント
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
