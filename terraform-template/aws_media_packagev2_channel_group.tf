#---------------------------------------------------------------
# AWS Elemental MediaPackage Version 2 Channel Group
#---------------------------------------------------------------
#
# AWS Elemental MediaPackage Version 2のチャネルグループをプロビジョニングするリソースです。
# チャネルグループは、複数のチャネルを論理的にグループ化するコンテナとして機能し、
# ライブ動画コンテンツの配信を管理するための組織単位を提供します。
# チャネルグループ内のすべてのチャネルは共通のegress domainを共有します。
#
# AWS公式ドキュメント:
#   - MediaPackage v2概要: https://docs.aws.amazon.com/mediapackage/latest/ug/what-is.html
#   - チャネルグループの作成: https://docs.aws.amazon.com/mediapackage/latest/ug/creating-channel-groups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/media_packagev2_channel_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_media_packagev2_channel_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: チャネルグループを識別するための一意の名前を指定します。
  # 設定可能な値: 英数字、ハイフン（-）、アンダースコア（_）を含む文字列
  # 注意: チャネルグループ名はアカウント内で一意である必要があります
  # 参考: https://docs.aws.amazon.com/mediapackage/latest/ug/channel-group-requirements.html
  name = "example"

  # description (Optional)
  # 設定内容: チャネルグループの説明を指定します。
  # 設定可能な値: 任意の文字列（最大256文字）
  # 用途: チャネルグループの目的や用途を記述して管理を容易にします
  # 省略時: 説明は設定されません
  description = "channel group for example channels"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: MediaPackage v2は特定のリージョンでのみ利用可能です
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

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
    Name        = "example-channel-group"
    Environment = "production"
    Service     = "media-streaming"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: チャネルグループのAmazon Resource Name (ARN)
#   形式: arn:aws:mediapackagev2:region:account-id:channelGroup/name
#
# - egress_domain: チャネルグループのegress domain
#   説明: このチャネルグループ内のすべてのチャネルで使用される
#        共通のドメイン名。クライアントがコンテンツを取得する際に
#        使用されるエンドポイントのベースURLとして機能します。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 基本的な使用例:
#
# resource "aws_media_packagev2_channel_group" "main" {
#   name        = "production-streaming"
#   description = "Production live streaming channel group"
#
#---------------------------------------------------------------
