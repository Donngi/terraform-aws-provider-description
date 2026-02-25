#---------------------------------------------------------------
# AWS Network Manager Customer Gateway Association
#---------------------------------------------------------------
#
# AWS Network Managerのグローバルネットワークにカスタマーゲートウェイを
# デバイスおよびオプションのリンクに関連付けるリソースです。
# カスタマーゲートウェイはVPNサイト間接続で使用されるゲートウェイです。
#
# AWS公式ドキュメント:
#   - Network Manager 概要: https://docs.aws.amazon.com/networkmanager/latest/userguide/what-are-global-networks.html
#   - AssociateCustomerGateway API: https://docs.aws.amazon.com/networkmanager/latest/APIReference/API_AssociateCustomerGateway.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_customer_gateway_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_customer_gateway_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # global_network_id (Required)
  # 設定内容: 関連付けを作成するグローバルネットワークのIDを指定します。
  # 設定可能な値: 既存のNetwork Managerグローバルネットワークのリソースいずれかのid属性
  global_network_id = "example-global-network-id"

  # customer_gateway_arn (Required)
  # 設定内容: 関連付けるカスタマーゲートウェイのARNを指定します。
  # 設定可能な値: 有効なカスタマーゲートウェイのARN
  #              例: arn:aws:ec2:ap-northeast-1:123456789012:customer-gateway/cgw-xxxxxxxxxxxxxxxxx
  customer_gateway_arn = "arn:aws:ec2:ap-northeast-1:123456789012:customer-gateway/cgw-xxxxxxxxxxxxxxxxx"

  # device_id (Required)
  # 設定内容: カスタマーゲートウェイを関連付けるデバイスのIDを指定します。
  # 設定可能な値: グローバルネットワーク内の既存デバイスのID
  device_id = "example-device-id"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # link_id (Optional)
  # 設定内容: カスタマーゲートウェイを関連付けるリンクのIDを指定します。
  # 設定可能な値: グローバルネットワーク内の既存リンクのID
  # 省略時: リンクへの関連付けは行われません
  link_id = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "10m", "2h" のような時間文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "10m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "10m", "2h" のような時間文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 関連付けの一意なID。
#       `global_network_id`、`customer_gateway_arn`、`device_id` を
#       コンマ区切りで結合した形式。
#---------------------------------------------------------------
