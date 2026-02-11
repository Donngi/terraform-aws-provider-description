#---------------------------------------------------------------
# AWS VPN Gateway Route Propagation
#---------------------------------------------------------------
#
# VPNゲートウェイとルートテーブル間の自動ルート伝播を設定するリソースです。
# このリソースを使用すると、VPN接続を通じて学習したルートが
# 指定したルートテーブルに自動的に伝播されます。
#
# AWS公式ドキュメント:
#   - ルートテーブルの優先度: https://docs.aws.amazon.com/vpc/latest/userguide/route-tables-priority.html
#   - Site-to-Site VPNのルート優先度: https://docs.aws.amazon.com/vpn/latest/s2svpn/vpn-route-priority.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway_route_propagation
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpn_gateway_route_propagation" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # vpn_gateway_id (Required)
  # 設定内容: ルートを伝播するVPNゲートウェイのIDを指定します。
  # 設定可能な値: aws_vpn_gatewayリソースのID
  # 関連機能: VPNゲートウェイのルート伝播
  #   VPNゲートウェイは、Site-to-Site VPN接続を通じて学習したルートを
  #   関連付けられたルートテーブルに自動的に伝播します。
  #   - https://docs.aws.amazon.com/vpn/latest/s2svpn/vpn-route-priority.html
  vpn_gateway_id = aws_vpn_gateway.example.id

  # route_table_id (Required)
  # 設定内容: ルートを伝播するルートテーブルのIDを指定します。
  # 設定可能な値: aws_route_tableリソースのID
  # 関連機能: ルートテーブルへのルート伝播
  #   ルートテーブルでルート伝播が有効になると、VPN接続から学習したルートが
  #   自動的にルートテーブルに追加されます。伝播されたルートと静的ルートが
  #   同じ宛先を持つ場合、静的ルートが優先されます。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/route-tables-priority.html
  # 注意: propagating_vgws引数が設定されているルートテーブルでは
  #       このリソースを使用しないでください。その引数が設定されている場合、
  #       明示的にリストされていないルート伝播は削除されます。
  route_table_id = aws_route_table.example.id

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
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・削除操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "5m", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト値を使用
    create = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "5m", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト値を使用
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: VPNゲートウェイIDとルートテーブルIDの組み合わせ
#       形式: {vpn_gateway_id}_{route_table_id}
#
#---------------------------------------------------------------
