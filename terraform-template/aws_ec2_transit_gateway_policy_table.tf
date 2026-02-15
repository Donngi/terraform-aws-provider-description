#---------------------------------------
# aws_ec2_transit_gateway_policy_table
#---------------------------------------
# 最終更新: 2026-02-15
# Provider Version: 6.28.0
# Generated: 2026-02-15
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_policy_table
#
# NOTE: このテンプレートは参考例です。実際の使用環境に合わせて適宜変更してください。
#
# EC2 Transit Gateway Policy Tableの管理
#
# このリソースはAWS Cloud WANで使用されるTransit Gateway Policy Tableを作成します。
# ポリシーテーブルは動的ルーティングに使用され、ネットワークトラフィックを
# ポリシー属性に基づいてマッチングし、ターゲットルートテーブルにマップします。
#
# 注意事項:
# - Transit Gateway Policy TableはCloud WAN内でTransit Gatewayピアリング接続を
#   作成する場合にのみサポートされます
# - 通常のTransit Gatewayルーティングにはaws_ec2_transit_gateway_route_tableを使用してください
# - ポリシーテーブルの作成/削除はCloud WAN環境が必要です
#
# 関連リソース:
# - aws_ec2_transit_gateway: Transit Gatewayの作成
# - aws_ec2_transit_gateway_route_table: 標準的なルートテーブルの作成
# - aws_networkmanager_core_network: Cloud WANコアネットワークの管理
#
# 参考: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-policy-tables.html

#---------------------------------------
# 基本設定
#---------------------------------------

resource "aws_ec2_transit_gateway_policy_table" "example" {
  # 設定内容: ポリシーテーブルを作成するTransit GatewayのID
  # 設定可能な値: 既存のTransit Gateway ID (tgw-xxxxxxxxxxxxxxxxx形式)
  # 必須: はい
  # 注意: Cloud WANに関連付けられたTransit Gatewayである必要があります
  transit_gateway_id = "tgw-0123456789abcdef0"

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # 設定内容: このリソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード (us-east-1, ap-northeast-1等)
  # 省略時: プロバイダー設定のリージョンが使用されます
  # 注意: Transit Gatewayと同じリージョンを指定する必要があります
  region = "us-east-1"

  #---------------------------------------
  # タグ設定
  #---------------------------------------

  # 設定内容: リソースに付与するタグ
  # 設定可能な値: キー・バリュー形式のマップ
  # 省略時: タグなし
  # 注意: provider default_tagsと組み合わせて使用可能
  tags = {
    Name        = "my-tgw-policy-table"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# このリソースは以下の属性を出力します:
#
# - id: Transit Gateway Policy TableのID (例: tgw-rtb-policy-xxxxxxxxxxxxxxxxx)
# - arn: リソースのARN
# - state: ポリシーテーブルの状態
#   値: pending | available | deleting | deleted
# - tags_all: リソースに付与された全タグ
#   (provider default_tagsとマージされた結果)
