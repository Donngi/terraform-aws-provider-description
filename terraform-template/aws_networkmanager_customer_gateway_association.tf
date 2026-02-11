#---------------------------------------------------------------
# AWS Network Manager Customer Gateway Association
#---------------------------------------------------------------
#
# カスタマーゲートウェイをAWS Network Manager内のデバイスに関連付けるリソース。
# オプションでリンクも指定可能。リンクを指定する場合は、そのリンクが
# 指定されたデバイスに既に関連付けられている必要がある。
#
# これにより、オンプレミスネットワークをグローバルネットワークに追加し、
# ネットワークトポロジーの可視化と監視が可能になる。
#
# AWS公式ドキュメント:
#   - Gateway associations: https://docs.aws.amazon.com/network-manager/latest/tgwnm/gw-association.html
#   - Associate a customer gateway: https://docs.aws.amazon.com/network-manager/latest/tgwnm/nm-cgw-associate.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/networkmanager_customer_gateway_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_customer_gateway_association" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # global_network_id (Required, Forces new resource)
  # グローバルネットワークのID。
  # カスタマーゲートウェイを関連付けるNetwork Managerのグローバルネットワークを指定。
  # この値を変更するとリソースが再作成される。
  global_network_id = aws_networkmanager_global_network.example.id

  # customer_gateway_arn (Required, Forces new resource)
  # カスタマーゲートウェイのARN。
  # 関連付けるカスタマーゲートウェイを指定。
  # カスタマーゲートウェイは事前に作成され、Transit Gatewayにアタッチされている必要がある。
  # この値を変更するとリソースが再作成される。
  customer_gateway_arn = aws_customer_gateway.example.arn

  # device_id (Required, Forces new resource)
  # デバイスのID。
  # カスタマーゲートウェイを関連付けるNetwork Manager内のデバイスを指定。
  # デバイスは事前にグローバルネットワーク内に作成されている必要がある。
  # この値を変更するとリソースが再作成される。
  device_id = aws_networkmanager_device.example.id

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # link_id (Optional, Forces new resource)
  # リンクのID。
  # カスタマーゲートウェイをデバイスだけでなく、特定のリンクにも関連付ける場合に指定。
  # 指定するリンクは、device_idで指定したデバイスに既に関連付けられている必要がある。
  # この値を変更するとリソースが再作成される。
  # link_id = aws_networkmanager_link.example.id

  #---------------------------------------------------------------
  # タイムアウト設定 (Timeouts)
  #---------------------------------------------------------------

  # timeouts (Optional)
  # リソースの作成・削除に関するタイムアウト値を設定。
  # 関連付け処理には時間がかかる場合があるため、必要に応じて調整。
  # timeouts {
  #   # create (Optional)
  #   # リソース作成時のタイムアウト。デフォルト: 10m
  #   # 例: "30m", "1h"
  #   create = "10m"
  #
  #   # delete (Optional)
  #   # リソース削除時のタイムアウト。デフォルト: 10m
  #   # 例: "30m", "1h"
  #   delete = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# 上記の引数に加え、以下の属性がエクスポートされる:
#
# id - カスタマーゲートウェイの関連付けID
#      形式: {global_network_id},{customer_gateway_arn}
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
#
# 既存のカスタマーゲートウェイ関連付けをインポートするには、
# グローバルネットワークIDとカスタマーゲートウェイARNをカンマ区切りで指定:
#
# terraform import aws_networkmanager_customer_gateway_association.example \
#   global-network-12345678901234567,arn:aws:ec2:us-west-2:123456789012:customer-gateway/cgw-12345678
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 前提条件と依存関係
#---------------------------------------------------------------
#
# このリソースを使用する前に、以下のリソースが必要:
#
# 1. aws_networkmanager_global_network - グローバルネットワーク
# 2. aws_networkmanager_device - デバイス（サイトに関連付け済み）
# 3. aws_customer_gateway - カスタマーゲートウェイ
# 4. aws_ec2_transit_gateway - Transit Gateway
# 5. aws_vpn_connection - VPN接続（カスタマーゲートウェイとTransit Gateway間）
# 6. aws_networkmanager_transit_gateway_registration - Transit Gateway登録
#
# 依存関係の例:
#   depends_on = [aws_networkmanager_transit_gateway_registration.example]
#
#---------------------------------------------------------------
