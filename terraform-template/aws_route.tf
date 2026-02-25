#---------------------------------------------------------------
# Amazon VPC Route
#---------------------------------------------------------------
#
# VPCのルートテーブルにルートエントリ（ルート）を作成するリソースです。
# ルートはIPトラフィックの宛先CIDRブロックまたはプレフィックスリストと、
# トラフィックを転送するターゲット（インターネットゲートウェイ、NATゲートウェイ、
# Transit Gateway等）を定義します。
#
# 注意: aws_route_tableリソースのインラインroute定義と、
#       aws_routeリソースを同時に使用することはできません。
#       混在するとルール設定の競合が発生します。
#
# AWS公式ドキュメント:
#   - VPCルートテーブルの設定: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html
#   - ルートテーブルの概念: https://docs.aws.amazon.com/vpc/latest/userguide/RouteTables.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # route_table_id (Required)
  # 設定内容: ルートを追加するルートテーブルのIDを指定します。
  # 設定可能な値: 有効なルートテーブルID（例: rtb-12345678）
  route_table_id = "rtb-12345678"

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
  # ルート宛先設定
  # 以下のいずれか1つを指定する必要があります。
  #-------------------------------------------------------------

  # destination_cidr_block (Optional)
  # 設定内容: IPv4形式のルート宛先CIDRブロックを指定します。
  # 設定可能な値: 有効なIPv4 CIDRブロック（例: 0.0.0.0/0, 10.0.0.0/16）
  # 注意: destination_ipv6_cidr_block、destination_prefix_list_idと排他的
  destination_cidr_block = "0.0.0.0/0"

  # destination_ipv6_cidr_block (Optional)
  # 設定内容: IPv6形式のルート宛先CIDRブロックを指定します。
  # 設定可能な値: 有効なIPv6 CIDRブロック（例: ::/0）
  # 注意: destination_cidr_block、destination_prefix_list_idと排他的
  destination_ipv6_cidr_block = null

  # destination_prefix_list_id (Optional)
  # 設定内容: 宛先として使用するマネージドプレフィックスリストのIDを指定します。
  # 設定可能な値: 有効なプレフィックスリストID（例: pl-12345678）
  # 注意: destination_cidr_block、destination_ipv6_cidr_blockと排他的
  # 注意: Gateway VPCエンドポイント（S3等）にプレフィックスリストを関連付ける場合は
  #       aws_vpc_endpoint_route_table_associationリソースを使用すること
  destination_prefix_list_id = null

  #-------------------------------------------------------------
  # ルートターゲット設定
  # 以下のいずれか1つを指定する必要があります。
  #-------------------------------------------------------------

  # gateway_id (Optional)
  # 設定内容: VPCインターネットゲートウェイまたは仮想プライベートゲートウェイのIDを指定します。
  # 設定可能な値: 有効なインターネットゲートウェイID（igw-xxxxxxxx）または
  #               仮想プライベートゲートウェイID（vgw-xxxxxxxx）
  # 省略時: インポート済みローカルルートを更新する場合は "local" を指定
  # 注意: NATゲートウェイやEgress Only Internet GatewayのIDをこの属性に指定すると
  #       Terraformが永続的なdiffを報告します。それらには専用属性を使用すること
  gateway_id = "igw-12345678"

  # nat_gateway_id (Optional)
  # 設定内容: VPC NATゲートウェイのIDを指定します。
  # 設定可能な値: 有効なNATゲートウェイID（例: nat-12345678）
  # 用途: プライベートサブネットからのインターネットアクセスに使用
  nat_gateway_id = null

  # egress_only_gateway_id (Optional)
  # 設定内容: VPC Egress Only Internet GatewayのIDを指定します。
  # 設定可能な値: 有効なEgress Only Internet GatewayID（例: eigw-12345678）
  # 用途: IPv6トラフィックのアウトバウンド専用インターネットアクセスに使用
  egress_only_gateway_id = null

  # transit_gateway_id (Optional)
  # 設定内容: EC2 Transit GatewayのIDを指定します。
  # 設定可能な値: 有効なTransit GatewayID（例: tgw-12345678）
  # 用途: 複数VPCやオンプレミス環境との接続ハブとして使用
  transit_gateway_id = null

  # vpc_peering_connection_id (Optional)
  # 設定内容: VPCピアリング接続のIDを指定します。
  # 設定可能な値: 有効なVPCピアリング接続ID（例: pcx-12345678）
  # 用途: VPC間のプライベート通信に使用
  # 参考: https://docs.aws.amazon.com/vpc/latest/peering/vpc-peering-routing.html
  vpc_peering_connection_id = null

  # vpc_endpoint_id (Optional)
  # 設定内容: VPCエンドポイントのIDを指定します。
  # 設定可能な値: 有効なVPCエンドポイントID（例: vpce-12345678）
  # 用途: Gateway Load Balancerエンドポイント等へのルーティングに使用
  vpc_endpoint_id = null

  # network_interface_id (Optional)
  # 設定内容: EC2ネットワークインターフェースのIDを指定します。
  # 設定可能な値: 有効なネットワークインターフェースID（例: eni-12345678）
  # 用途: 仮想アプライアンス等を経由するルーティングに使用
  network_interface_id = null

  # local_gateway_id (Optional)
  # 設定内容: Outpostのローカルゲートウェイのプレフィックスリストを指定します。
  # 設定可能な値: 有効なOutpostローカルゲートウェイID（例: lgw-12345678）
  # 用途: AWS Outpostsのローカルゲートウェイへのルーティングに使用
  local_gateway_id = null

  # carrier_gateway_id (Optional)
  # 設定内容: キャリアゲートウェイのIDを指定します。
  # 設定可能な値: 有効なキャリアゲートウェイID（例: cagw-12345678）
  # 注意: VPCにWavelengthゾーンに関連付けられたサブネットが含まれている場合のみ使用可能
  carrier_gateway_id = null

  # core_network_arn (Optional)
  # 設定内容: AWS Cloud WAN コアネットワークのARNを指定します。
  # 設定可能な値: 有効なコアネットワークARN
  # 用途: AWS Cloud WANのコアネットワークへのルーティングに使用
  core_network_arn = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成完了を待機する最大時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "5m", "30s", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "5m"

    # update (Optional)
    # 設定内容: リソース更新完了を待機する最大時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "5m", "30s", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "5m"

    # delete (Optional)
    # 設定内容: リソース削除完了を待機する最大時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "5m", "30s", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ルートテーブルIDとルート宛先から算出されるルート識別子
# - instance_id: EC2インスタンスの識別子
# - instance_owner_id: EC2インスタンスの所有者AWSアカウントID
# - origin: ルートの作成方法 (CreateRouteTable / CreateRoute / EnableVgwRoutePropagation)
# - state: ルートの状態 (active / blackhole)
#---------------------------------------------------------------
