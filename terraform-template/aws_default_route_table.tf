#---------------------------------------------------------------
# AWS VPC Default Route Table
#---------------------------------------------------------------
#
# VPCのデフォルトルートテーブルを管理するリソースです。
# デフォルトVPCまたは非デフォルトVPCのデフォルトルートテーブルを管理できます。
#
# 重要な注意事項:
#   - これは特別な注意が必要な高度なリソースです。
#   - Terraformはこのリソースを「作成」するのではなく、既存のものを管理に「採用」します。
#   - Terraformが初めてデフォルトルートテーブルを採用する際、定義されているすべてのルートが
#     即座に削除されます。その後、設定で指定されたルートが作成されます。
#   - aws_default_route_tableとaws_main_route_table_associationを同じVPCで
#     同時に使用しないでください。ルートの競合が発生する可能性があります。
#
# AWS公式ドキュメント:
#   - VPCルートテーブル: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_default_route_table" "example" {
  #-------------------------------------------------------------
  # 基本設定 (Required)
  #-------------------------------------------------------------

  # default_route_table_id (Required)
  # 設定内容: デフォルトルートテーブルのIDを指定します。
  # 設定可能な値: VPCのデフォルトルートテーブルID
  # 注意: 通常はaws_vpc.example.default_route_table_idを参照します
  default_route_table_id = aws_vpc.example.default_route_table_id

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # Virtual Gateway伝播設定
  #-------------------------------------------------------------

  # propagating_vgws (Optional)
  # 設定内容: ルート伝播に使用するVirtual Private Gatewayのリストを指定します。
  # 設定可能な値: VPNゲートウェイIDのセット
  # 関連機能: VPN接続とDirect Connect
  #   Virtual Private Gatewayをルートテーブルに関連付けることで、
  #   VPN接続やDirect Connect経由で学習したルートが自動的に伝播されます。
  propagating_vgws = [
    # aws_vpn_gateway.example.id
  ]

  #-------------------------------------------------------------
  # ルート設定
  #-------------------------------------------------------------

  # route (Optional)
  # 設定内容: ルートの設定ブロックを指定します。
  # 注意:
  #   - このargumentはattribute-as-blocksモードで処理されます
  #   - 引数を省略すると、既存のルートが無視されます
  #   - すべての管理対象ルートを削除するには、空のリスト（route = []）を指定します
  #   - VPCのCIDRブロックを"local"にマッピングするデフォルトルートは
  #     暗黙的に作成され、指定できません
  #
  # 各routeブロックには以下を指定します:
  #   - 宛先（cidr_block, ipv6_cidr_block, destination_prefix_list_idのいずれか）
  #   - ターゲット（以下のいずれか1つ）
  route {
    # cidr_block (Required in route block)
    # 設定内容: ルートのCIDRブロックを指定します。
    # 設定可能な値: IPv4 CIDRブロック（例: "10.0.1.0/24", "0.0.0.0/0"）
    cidr_block = "10.0.1.0/24"

    # gateway_id (Optional)
    # 設定内容: VPCインターネットゲートウェイまたはVirtual Private Gatewayの識別子を指定します。
    # 設定可能な値: Internet GatewayまたはVPN GatewayのID
    gateway_id = aws_internet_gateway.example.id
  }

  # IPv6ルートの例
  route {
    # ipv6_cidr_block (Optional)
    # 設定内容: ルートのIPv6 CIDRブロックを指定します。
    # 設定可能な値: IPv6 CIDRブロック（例: "::/0"）
    ipv6_cidr_block = "::/0"

    # egress_only_gateway_id (Optional)
    # 設定内容: VPC Egress Only Internet Gatewayの識別子を指定します。
    # 設定可能な値: Egress Only Internet GatewayのID
    # 注意: IPv6トラフィック専用。インバウンドトラフィックをブロックしながら
    #       アウトバウンドIPv6トラフィックを許可します
    egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
  }

  # その他のターゲットタイプの例（コメントアウト）
  # route {
  #   cidr_block = "10.1.0.0/16"
  #
  #   # core_network_arn (Optional)
  #   # 設定内容: Cloud WANコアネットワークのAmazon Resource Name (ARN)を指定します。
  #   # 設定可能な値: コアネットワークのARN
  #   core_network_arn = "arn:aws:networkmanager::123456789012:core-network/core-network-12345"
  # }

  # route {
  #   cidr_block = "10.2.0.0/16"
  #
  #   # destination_prefix_list_id (Optional)
  #   # 設定内容: 管理プレフィックスリストの宛先IDを指定します。
  #   # 設定可能な値: 管理プレフィックスリストのID
  #   # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_managed_prefix_list
  #   destination_prefix_list_id = aws_ec2_managed_prefix_list.example.id
  # }

  # route {
  #   cidr_block = "10.3.0.0/16"
  #
  #   # instance_id (Optional)
  #   # 設定内容: EC2インスタンスの識別子を指定します（NATインスタンスとして使用）。
  #   # 設定可能な値: EC2インスタンスID
  #   # 注意: NATインスタンスを使用する場合に指定
  #   instance_id = aws_instance.nat.id
  # }

  # route {
  #   cidr_block = "10.4.0.0/16"
  #
  #   # nat_gateway_id (Optional)
  #   # 設定内容: VPC NATゲートウェイの識別子を指定します。
  #   # 設定可能な値: NAT GatewayのID
  #   nat_gateway_id = aws_nat_gateway.example.id
  # }

  # route {
  #   cidr_block = "10.5.0.0/16"
  #
  #   # network_interface_id (Optional)
  #   # 設定内容: EC2ネットワークインターフェースの識別子を指定します。
  #   # 設定可能な値: ネットワークインターフェースID
  #   network_interface_id = aws_network_interface.example.id
  # }

  # route {
  #   cidr_block = "10.6.0.0/16"
  #
  #   # transit_gateway_id (Optional)
  #   # 設定内容: EC2 Transit Gatewayの識別子を指定します。
  #   # 設定可能な値: Transit GatewayのID
  #   transit_gateway_id = aws_ec2_transit_gateway.example.id
  # }

  # route {
  #   cidr_block = "10.7.0.0/16"
  #
  #   # vpc_endpoint_id (Optional)
  #   # 設定内容: VPCエンドポイントの識別子を指定します。
  #   # 設定可能な値: VPC Endpoint ID（Gateway Load Balancer Endpoint）
  #   # 注意: VPCエンドポイントを削除する前に、このルートを削除する必要があります
  #   vpc_endpoint_id = aws_vpc_endpoint.example.id
  # }

  # route {
  #   cidr_block = "10.8.0.0/16"
  #
  #   # vpc_peering_connection_id (Optional)
  #   # 設定内容: VPCピアリング接続の識別子を指定します。
  #   # 設定可能な値: VPC Peering Connection ID
  #   vpc_peering_connection_id = aws_vpc_peering_connection.example.id
  # }

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
    Name        = "example-default-route-table"
    Environment = "production"
  }

  # tags_all (Optional)
  # 設定内容: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
  #          リソースに割り当てるすべてのタグのマップです。
  # 注意: 通常は直接設定せず、tagsとdefault_tagsから自動計算されます
  # tags_all = {}

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト値をカスタマイズするブロックです。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト値を指定します。
    # 設定可能な値: 時間を表す文字列（例: "5m", "10s", "1h"）
    # 省略時: デフォルトのタイムアウト値
    create = "5m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト値を指定します。
    # 設定可能な値: 時間を表す文字列（例: "5m", "10s", "1h"）
    # 省略時: デフォルトのタイムアウト値
    update = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ルートテーブルのID
#
# - arn: ルートテーブルのAmazon Resource Name (ARN)
#
# - owner_id: ルートテーブルを所有するAWSアカウントのID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# - vpc_id: VPCのID
#---------------------------------------------------------------
