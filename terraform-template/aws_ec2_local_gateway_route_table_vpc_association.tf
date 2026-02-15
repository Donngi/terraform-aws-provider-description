#---------------------------------------
# aws_ec2_local_gateway_route_table_vpc_association
#---------------------------------------
# 用途: AWS OutpostsのローカルゲートウェイルートテーブルとVPCの関連付けを管理
#
# 主な機能:
# - OutpostsラックのローカルゲートウェイルートテーブルとVPCの接続を確立
# - Outpostsサブネット内のリソースとオンプレミスネットワーク間の通信を有効化
# - 直接VPCルーティングまたは顧客所有IPアドレス(CoIP)を使用した接続をサポート
#
# ユースケース:
# - OutpostsラックをVPCに接続し、オンプレミスネットワークとの通信を確立する場合
# - ハイブリッドクラウド環境でローカルゲートウェイを介したネットワーク接続を構築する場合
# - Outpostsサブネット内のEC2インスタンスがオンプレミスリソースにアクセスする必要がある場合
#
# 関連リソース:
# - aws_ec2_local_gateway_route_table: ローカルゲートウェイルートテーブル
# - aws_vpc: 関連付けられるVPC
# - aws_ec2_local_gateway_route: ローカルゲートウェイのルート設定
# - aws_ec2_local_gateway_route_table_virtual_interface_group_association: VIFグループとの関連付け
#
# 参考ドキュメント:
# https://docs.aws.amazon.com/outposts/latest/userguide/outposts-local-gateways.html#vpc-associations
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ec2_local_gateway_route_table_vpc_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-15
#
# NOTE:
# - ローカルゲートウェイはAWS Outpostsラックのインストール時に自動作成される
# - ルートテーブルとVPCの関連付けにより、Outpostsサブネットとオンプレミスネットワーク間の通信が可能になる
# - 関連付けを作成する前に、ローカルゲートウェイルートテーブルとVIFグループの関連付けが必要
# - 一つのVPCに対して複数のローカルゲートウェイルートテーブルを関連付けることはできない
#---------------------------------------

#---------------------------------------
# 必須パラメータ
#---------------------------------------

resource "aws_ec2_local_gateway_route_table_vpc_association" "example" {
  # 設定内容: ローカルゲートウェイルートテーブルのID
  # 設定可能な値: 有効なローカルゲートウェイルートテーブルID（lgw-rtb-xxxxxxxxxxxxxxxxx形式）
  # ユースケース:
  # - AWS Outpostsラック用に作成されたルートテーブルを指定
  # - オンプレミスネットワークへのルーティングを定義したテーブルを関連付け
  local_gateway_route_table_id = data.aws_ec2_local_gateway_route_table.example.id

  # 設定内容: 関連付けるVPCのID
  # 設定可能な値: 有効なVPC ID（vpc-xxxxxxxxxxxxxxxxx形式）
  # ユースケース:
  # - Outpostsサブネットを含むVPCを指定
  # - ローカルゲートウェイを介してオンプレミスネットワークと通信するVPCを関連付け
  vpc_id = aws_vpc.example.id

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # 設定内容: リソースを管理するリージョン
  # 設定可能な値: 有効なAWSリージョン名（us-east-1, ap-northeast-1など）
  # 省略時: プロバイダー設定のリージョンを使用
  # ユースケース:
  # - 特定のリージョンでリソースを明示的に管理する場合
  # - マルチリージョン構成で各リソースのリージョンを明確にする場合
  region = "us-west-2"

  #---------------------------------------
  # タグ設定
  #---------------------------------------

  # 設定内容: リソースに付与するタグのキーバリューマップ
  # 設定可能な値: 任意の文字列キーと文字列値のマップ
  # 省略時: タグなし（プロバイダーのdefault_tagsは適用される）
  # ユースケース:
  # - リソースの分類、コスト配分、管理用のメタデータを設定
  # - 環境（本番/開発）、所有者、プロジェクト名などを識別
  # tags = {
  #   Name        = "example-lgw-vpc-association"
  #   Environment = "production"
  #   Outpost     = "outpost-1"
  # }
}

#---------------------------------------
# データソース参照例
#---------------------------------------

# ローカルゲートウェイルートテーブルの取得
data "aws_ec2_local_gateway_route_table" "example" {
  outpost_arn = "arn:aws:outposts:us-west-2:123456789012:outpost/op-1234567890abcdef"
}

# 関連付けるVPCの定義
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "outpost-vpc"
  }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# このリソースでは以下の属性が参照可能:
#
# id - ローカルゲートウェイルートテーブルVPC関連付けID（lgw-vpc-assoc-xxxxxxxxxxxxxxxxx形式）
# local_gateway_id - 関連付けられているローカルゲートウェイのID
# local_gateway_route_table_id - 関連付けられているローカルゲートウェイルートテーブルのID
# vpc_id - 関連付けられているVPCのID
# tags_all - リソースに割り当てられた全てのタグ（プロバイダーのdefault_tagsを含む）
#
# 参照方法の例:
# - ローカルゲートウェイID: aws_ec2_local_gateway_route_table_vpc_association.example.local_gateway_id
# - 関連付けID: aws_ec2_local_gateway_route_table_vpc_association.example.id
