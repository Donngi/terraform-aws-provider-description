# ==============================================================================
# Terraform AWS Resource Template: aws_ec2_local_gateway_route
# ==============================================================================
# Generated: 2026-01-23
# Provider Version: 6.28.0
#
# このテンプレートは生成時点（2026-01-23）の情報に基づいています。
# 最新の仕様については、公式ドキュメントを確認してください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_local_gateway_route
#
# AWS Outposts Local Gateway Route
# AWS Outpostsラックのローカルゲートウェイルートを管理します。
# ローカルゲートウェイは、OutpostサブネットとオンプレミスネットワークまたはAWSリージョン間の
# 接続を有効にするネットワークコンポーネントです。
# ==============================================================================

resource "aws_ec2_local_gateway_route" "example" {
  # ==============================================================================
  # Required Arguments - 必須引数
  # ==============================================================================

  # destination_cidr_block (Required) - 宛先CIDRブロック
  # 説明:
  #   - ルーティング判断に使用されるIPv4 CIDR範囲
  #   - ルーティング決定は最も具体的な一致に基づいて行われます
  #   - オンプレミスネットワークへのトラフィックをルーティングするために使用されます
  # タイプ: string
  # 例: "172.16.0.0/16", "10.0.0.0/8"
  # 参考: https://docs.aws.amazon.com/outposts/latest/userguide/routing.html
  destination_cidr_block = "172.16.0.0/16"

  # local_gateway_route_table_id (Required) - ローカルゲートウェイルートテーブルID
  # 説明:
  #   - EC2ローカルゲートウェイルートテーブルの識別子
  #   - ローカルゲートウェイルートテーブルは、Outpostサブネット内のインスタンスが
  #     オンプレミスネットワークと通信する方法を決定します
  #   - 各Outpostsラックには1つのローカルゲートウェイが作成され、
  #     そのオーナーがローカルゲートウェイルートテーブルを作成・管理します
  # タイプ: string
  # 参考: https://docs.aws.amazon.com/outposts/latest/userguide/outposts-local-gateways.html
  local_gateway_route_table_id = data.aws_ec2_local_gateway_route_table.example.id

  # local_gateway_virtual_interface_group_id (Required) - ローカルゲートウェイ仮想インターフェースグループID
  # 説明:
  #   - EC2ローカルゲートウェイ仮想インターフェースグループ（VIF Group）の識別子
  #   - VIFグループは、Outpostsネットワークデバイスとオンプレミスネットワークデバイス間の
  #     VLAN、IP、BGP接続のセットアップを担当します
  #   - ローカルゲートウェイルートテーブルとVIFグループの関連付けにより、
  #     ローカルゲートウェイルーティングドメインが作成されます
  # タイプ: string
  # 参考: https://docs.aws.amazon.com/outposts/latest/userguide/outposts-local-gateways.html
  local_gateway_virtual_interface_group_id = data.aws_ec2_local_gateway_virtual_interface_group.example.id

  # ==============================================================================
  # Optional Arguments - オプション引数
  # ==============================================================================

  # id (Optional) - リソースID
  # 説明:
  #   - EC2ローカルゲートウェイルートテーブル識別子と宛先CIDRブロックを
  #     アンダースコア（_）で区切った形式
  #   - 通常はTerraformが自動的に管理するため、明示的な指定は不要です
  # タイプ: string (Computed)
  # 例: "lgw-rtb-1234567890abcdef0_172.16.0.0/16"
  # id = "lgw-rtb-1234567890abcdef0_172.16.0.0/16"

  # region (Optional) - リージョン
  # 説明:
  #   - このリソースが管理されるAWSリージョン
  #   - 指定しない場合は、プロバイダー設定で指定されたリージョンがデフォルトとして使用されます
  #   - AWS Outpostsは特定のリージョンに関連付けられているため、
  #     通常はプロバイダーのリージョン設定と一致させます
  # タイプ: string (Computed)
  # 例: "us-east-1", "us-west-2", "ap-northeast-1"
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"
}

# ==============================================================================
# 補足情報
# ==============================================================================
#
# AWS Outposts Local Gateway Routeについて:
# - AWS Outpostsラックは、AWSインフラストラクチャとサービスをオンプレミスに拡張します
# - ローカルゲートウェイは、Outpostサブネットとオンプレミスネットワーク間の接続を提供します
# - ローカルゲートウェイルートは、トラフィックのルーティング方法を定義します
#
# ルーティングモード:
# 1. Direct VPC Routing（デフォルト）:
#    - VPC内のインスタンスのプライベートIPアドレスを使用
#    - BGPアドバタイズメントを通じてオンプレミスネットワークと通信
#    - 重複するCIDR範囲はサポートされません
#
# 2. Customer-owned IP (CoIP):
#    - カスタマー所有のIPアドレスプールを使用
#    - 重複するCIDR範囲やその他のネットワークトポロジをサポート
#    - Elastic IPアドレスをCoIPプールから割り当て可能
#
# ユースケース:
# - オンプレミスネットワークとOutpostサブネット間のカスタムルーティング
# - 特定のCIDR範囲のトラフィックを特定のVIFグループに転送
# - マルチサイトOutposts展開における複雑なネットワーク構成
#
# 制限事項:
# - ターゲットネットワークインターフェースは、Outpost上のサブネットに属している必要があります
# - ネットワークインターフェースルートは、同じルートテーブルで100まで
# - インターフェースVPCエンドポイントはサポートされていません
#
# 参考リンク:
# - AWS Outposts User Guide - Local Gateways:
#   https://docs.aws.amazon.com/outposts/latest/userguide/outposts-local-gateways.html
# - Local Gateway Route Tables:
#   https://docs.aws.amazon.com/outposts/latest/userguide/routing.html
# - Terraform AWS Provider Documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_local_gateway_route
#
# ==============================================================================
