#---------------------------------------------------------------
# AWS WorkSpaces Web Network Settings
#---------------------------------------------------------------
#
# Amazon WorkSpaces Secure Browserのネットワーク設定リソースを
# プロビジョニングします。
# VPC・サブネット・セキュリティグループを指定することで、
# ストリーミングインスタンスが利用するネットワーク環境を定義します。
# 作成後に aws_workspacesweb_network_settings_association リソースを
# 使用してWebポータルに関連付けることで設定が適用されます。
#
# AWS公式ドキュメント:
#   - ネットワーク設定概要: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/network-settings.html
#   - CreateNetworkSettings API: https://docs.aws.amazon.com/workspaces-web/latest/APIReference/API_CreateNetworkSettings.html
#   - NetworkSettings: https://docs.aws.amazon.com/workspaces-web/latest/APIReference/API_NetworkSettings.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspacesweb_network_settings
#
# Provider Version: 6.28.0
# Generated: 2026-02-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_workspacesweb_network_settings" "example" {
  #-------------------------------------------------------------
  # ネットワーク設定（必須）
  #-------------------------------------------------------------

  # vpc_id (Required)
  # 設定内容: ストリーミングインスタンスが起動するVPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID（例: vpc-0123456789abcdef0）
  # 注意: 指定するVPCはWorkSpaces Webのストリーミングインスタンスが
  #       インターネットまたは社内ネットワークに接続できるよう
  #       適切にルーティングが構成されている必要があります。
  vpc_id = "vpc-0123456789abcdef0"

  # subnet_ids (Required)
  # 設定内容: ストリーミングインスタンスが配置されるサブネットのIDセットを指定します。
  # 設定可能な値: 有効なサブネットIDのセット（複数指定可能）
  # 注意: 高可用性のために複数のアベイラビリティーゾーンにわたる
  #       サブネットを指定することを推奨します。
  #       サブネットは vpc_id で指定したVPC内のものである必要があります。
  subnet_ids = [
    "subnet-0123456789abcdef0",
    "subnet-0fedcba9876543210",
  ]

  # security_group_ids (Required)
  # 設定内容: ストリーミングインスタンスに適用するセキュリティグループのIDセットを指定します。
  # 設定可能な値: 有効なセキュリティグループIDのセット（複数指定可能）
  # 注意: セキュリティグループは vpc_id で指定したVPC内のものである必要があります。
  #       ストリーミングインスタンスが必要なポートでの通信を許可するよう
  #       適切なルールを設定してください。
  security_group_ids = [
    "sg-0123456789abcdef0",
  ]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-network-settings"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - network_settings_arn: ネットワーク設定リソースのARN。
#
# - associated_portal_arns: このネットワーク設定に関連付けられている
#                           Webポータルの ARN のリスト。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
