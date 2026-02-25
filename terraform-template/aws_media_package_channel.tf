#---------------------------------------------------------------
# AWS Media Package Channel
#---------------------------------------------------------------
#
# AWS Elemental MediaPackageのチャンネルをプロビジョニングするリソースです。
# ライブビデオストリームを受信し、複数の出力フォーマット（HLS等）で
# 配信するためのIngress（受信）エンドポイントを提供します。
#
# AWS公式ドキュメント:
#   - AWS Elemental MediaPackage とは: https://docs.aws.amazon.com/mediapackage/latest/ug/what-is.html
#   - チャンネルの作成: https://docs.aws.amazon.com/mediapackage/latest/ug/channels.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/media_package_channel
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_media_package_channel" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # channel_id (Required)
  # 設定内容: MediaPackageチャンネルの一意なIDを指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む任意の文字列
  channel_id = "example-media-package-channel"

  # description (Optional)
  # 設定内容: チャンネルの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Example Media Package Channel"

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
  # 参考: プロバイダーレベルの default_tags と一致するキーはプロバイダー定義を上書きします
  tags = {
    Name        = "example-media-package-channel"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: MediaPackageチャンネルのARN
# - hls_ingest: HLS Ingestエンドポイント情報のリスト
#   - hls_ingest[*].ingest_endpoints: Ingestエンドポイントのリスト
#     - url: Ingestエンドポイントへのパッケージングコンテンツの取り込みURL
#     - username: Ingestエンドポイントの認証ユーザー名
#     - password: Ingestエンドポイントの認証パスワード
# - id: チャンネルID（channel_id と同値）
# - tags_all: プロバイダーのdefault_tagsを含む全タグマップ
#---------------------------------------------------------------
