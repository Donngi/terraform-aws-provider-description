#---------------------------------------------------------------
# AWS VPC ルートテーブル
#---------------------------------------------------------------
#
# Amazon VPCのルートテーブルをプロビジョニングするリソースです。
# ルートテーブルはサブネットやゲートウェイのネットワークトラフィックの
# 送信先を決定するルール（ルート）の集合です。各サブネットは1つの
# ルートテーブルに関連付けられ、トラフィックの宛先IPアドレスに基づいて
# 適切なターゲットへ転送されます。
#
# AWS公式ドキュメント:
#   - VPCルートテーブルの設定: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html
#   - ルートテーブルの作成: https://docs.aws.amazon.com/vpc/latest/userguide/create-vpc-route-table.html
#   - ルートテーブルの概念: https://docs.aws.amazon.com/vpc/latest/userguide/RouteTables.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route_table" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # vpc_id (Required)
  # 設定内容: ルートテーブルを作成するVPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID（例: vpc-12345678）
  vpc_id = "vpc-12345678"

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
  # ルート設定
  #-------------------------------------------------------------

  # route (Optional)
  # 設定内容: ルートオブジェクトのリストを指定します。attribute-as-blocksモードで処理されます。
  # 省略時: 既存のルートを無視する動作として解釈されます。全管理ルートを削除するには空リストを指定してください。
  # 注意: aws_route リソースとインラインの route ブロックは同時に使用できません。
  #       どちらか一方のみを使用してください。
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html

  # IPv4 CIDRを使ったインターネットゲートウェイへのルート例
  route {
    # cidr_block (Required - 宛先指定時はいずれか1つが必須)
    # 設定内容: ルートの宛先IPv4 CIDRブロックを指定します。
    # 設定可能な値: 有効なIPv4 CIDRブロック（例: 0.0.0.0/0, 10.0.1.0/24）
    # 注意: cidr_block または ipv6_cidr_block または destination_prefix_list_id のいずれか1つが必須
    cidr_block = "0.0.0.0/0"

    # ipv6_cidr_block (Optional)
    # 設定内容: ルートの宛先IPv6 CIDRブロックを指定します。
    # 設定可能な値: 有効なIPv6 CIDRブロック（例: ::/0）
    # 省略時: IPv6宛先なし
    ipv6_cidr_block = null

    # destination_prefix_list_id (Optional)
    # 設定内容: ルートの宛先としてマネージドプレフィックスリストのIDを指定します。
    # 設定可能な値: 有効なマネージドプレフィックスリストID（例: pl-12345678）
    # 省略時: プレフィックスリストを使用しない
    # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/managed-prefix-lists.html
    destination_prefix_list_id = null

    # gateway_id (Optional - ターゲット指定時はいずれか1つが必須)
    # 設定内容: VPCインターネットゲートウェイ、仮想プライベートゲートウェイ、またはlocalの識別子を指定します。
    # 設定可能な値: 有効なインターネットゲートウェイID（igw-xxxxx）、仮想プライベートゲートウェイID（vgw-xxxxx）、または "local"
    # 注意: "local" ルートは作成できませんが採用またはインポートが可能です。
    #       NAT GatewayのIDをgateway_idに指定するとpermanent diffが発生するため注意してください。
    gateway_id = "igw-12345678"

    # nat_gateway_id (Optional)
    # 設定内容: VPC NATゲートウェイの識別子を指定します。
    # 設定可能な値: 有効なNATゲートウェイID（例: nat-12345678）
    # 省略時: NATゲートウェイをターゲットとしない
    # 注意: nat_gateway_id と gateway_id を混同しないこと（permanent diffの原因になります）
    nat_gateway_id = null

    # carrier_gateway_id (Optional)
    # 設定内容: キャリアゲートウェイの識別子を指定します。
    # 設定可能な値: 有効なキャリアゲートウェイID
    # 省略時: キャリアゲートウェイをターゲットとしない
    # 注意: この属性はVPCにWavelength Zoneに関連付けられたサブネットが含まれる場合のみ使用可能
    carrier_gateway_id = null

    # core_network_arn (Optional)
    # 設定内容: AWS Cloud WAN コアネットワークのARNを指定します。
    # 設定可能な値: 有効なコアネットワークARN
    # 省略時: コアネットワークをターゲットとしない
    core_network_arn = null

    # egress_only_gateway_id (Optional)
    # 設定内容: VPC Egress Only Internet GatewayのIDを指定します。
    # 設定可能な値: 有効なEgress Only Internet Gateway ID（例: eigw-12345678）
    # 省略時: Egress Only Internet Gatewayをターゲットとしない
    # 注意: IPv6トラフィックのアウトバウンド専用経路として使用する場合に指定
    egress_only_gateway_id = null

    # local_gateway_id (Optional)
    # 設定内容: Outpostローカルゲートウェイの識別子を指定します。
    # 設定可能な値: 有効なOutpostローカルゲートウェイID
    # 省略時: ローカルゲートウェイをターゲットとしない
    local_gateway_id = null

    # network_interface_id (Optional)
    # 設定内容: EC2ネットワークインターフェイスの識別子を指定します。
    # 設定可能な値: 有効なENI ID（例: eni-12345678）
    # 省略時: ネットワークインターフェイスをターゲットとしない
    network_interface_id = null

    # transit_gateway_id (Optional)
    # 設定内容: EC2 Transit GatewayのIDを指定します。
    # 設定可能な値: 有効なTransit Gateway ID（例: tgw-12345678）
    # 省略時: Transit Gatewayをターゲットとしない
    transit_gateway_id = null

    # vpc_endpoint_id (Optional)
    # 設定内容: VPCエンドポイントの識別子を指定します。
    # 設定可能な値: 有効なVPCエンドポイントID（例: vpce-12345678）
    # 省略時: VPCエンドポイントをターゲットとしない
    vpc_endpoint_id = null

    # vpc_peering_connection_id (Optional)
    # 設定内容: VPCピアリング接続の識別子を指定します。
    # 設定可能な値: 有効なVPCピアリング接続ID（例: pcx-12345678）
    # 省略時: VPCピアリング接続をターゲットとしない
    # 注意: デフォルトルート（VPCのCIDRブロックを"local"にマッピング）は暗黙的に作成されるため指定不要
    vpc_peering_connection_id = null
  }

  #-------------------------------------------------------------
  # ルート伝播設定
  #-------------------------------------------------------------

  # propagating_vgws (Optional)
  # 設定内容: ルート伝播を行う仮想プライベートゲートウェイのリストを指定します。
  # 設定可能な値: 仮想プライベートゲートウェイID（vgw-xxxxx）の文字列セット
  # 省略時: ルート伝播なし
  # 注意: この引数を指定した場合、aws_vpn_gateway_route_propagation リソースとの
  #       併用はサポートされません。この引数に明示的にリストされていない伝播ゲートウェイは
  #       削除されます。ルート伝播には専用リソースを使用することを推奨します。
  propagating_vgws = []

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 参考: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-route-table"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {
    # create (Optional)
    # 設定内容: ルートテーブル作成操作のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "5m", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間を使用
    create = "5m"

    # update (Optional)
    # 設定内容: ルートテーブル更新操作のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "5m", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間を使用
    update = "5m"

    # delete (Optional)
    # 設定内容: ルートテーブル削除操作のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "5m", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間を使用
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ルートテーブルのID
# - arn: ルートテーブルのAmazon Resource Name (ARN)
# - owner_id: ルートテーブルを所有するAWSアカウントのID
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
