#---------------------------------------
# EC2ローカルゲートウェイルート
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-15
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ec2_local_gateway_route
#
# 用途: AWS Outpostsのローカルゲートウェイルートテーブルにルートを追加
# 機能: Outpost上のインスタンスからオンプレミスネットワークへのトラフィックルーティングを制御
# 関連サービス: AWS Outposts、EC2、VPC
#
# NOTE:
#   - AWS Outposts環境でのみ使用可能なリソース
#   - ローカルゲートウェイルートは、Outpost上のインスタンスとオンプレミスネットワーク間の通信を制御
#   - ルートは、対象のネットワークインターフェースが実行中のインスタンスにアタッチされている場合にのみアクティブ
#   - 1つのルートテーブルに最大100個のネットワークインターフェースルートを設定可能
#   - Direct VPC RoutingまたはCustomer-Owned IP (CoIP)モードをサポート
#   - BGPアドバタイズメントを通じてオンプレミスネットワークにルート情報を伝播

#------- 基本設定
resource "aws_ec2_local_gateway_route" "example" {
  # 設定内容: ルートの宛先CIDRブロック
  # 設定可能な値: IPv4 CIDR形式（例: 172.16.0.0/16）
  # 補足: ルーティング判断は最も具体的な一致に基づいて行われる
  destination_cidr_block = "172.16.0.0/16"

  # 設定内容: ローカルゲートウェイルートテーブルのID
  # 設定可能な値: EC2ローカルゲートウェイルートテーブルの識別子
  # 補足: AWS Outpostsに関連付けられたルートテーブルを指定
  local_gateway_route_table_id = data.aws_ec2_local_gateway_route_table.example.id

  # 設定内容: ローカルゲートウェイ仮想インターフェースグループのID
  # 設定可能な値: EC2ローカルゲートウェイ仮想インターフェースグループの識別子
  # 補足: トラフィックの転送先となるVIFグループを指定
  local_gateway_virtual_interface_group_id = data.aws_ec2_local_gateway_virtual_interface_group.example.id
}

#------- リージョン設定
resource "aws_ec2_local_gateway_route" "region_specific" {
  destination_cidr_block                   = "172.16.0.0/16"
  local_gateway_route_table_id             = data.aws_ec2_local_gateway_route_table.example.id
  local_gateway_virtual_interface_group_id = data.aws_ec2_local_gateway_virtual_interface_group.example.id

  # 設定内容: リソースが管理されるリージョン
  # 設定可能な値: AWSリージョンコード（例: us-east-1、ap-northeast-1）
  # 省略時: プロバイダー設定で指定されたリージョンを使用
  region = "us-east-1"
}

#------- Attributes Reference
# id - ローカルゲートウェイルートテーブルIDと宛先CIDRブロックをアンダースコア(_)で結合した識別子

#------- データソース例
# ローカルゲートウェイルートテーブルの取得
data "aws_ec2_local_gateway_route_table" "example" {
  outpost_arn = "arn:aws:outposts:us-east-1:123456789012:outpost/op-1234567890abcdef0"
}

# ローカルゲートウェイ仮想インターフェースグループの取得
data "aws_ec2_local_gateway_virtual_interface_group" "example" {
  local_gateway_id = data.aws_ec2_local_gateway_route_table.example.local_gateway_id
}
