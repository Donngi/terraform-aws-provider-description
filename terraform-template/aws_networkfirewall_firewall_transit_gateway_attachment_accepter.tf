#---------------------------------------------------------------
# AWS Network Firewall Transit Gateway Attachment Accepter
#---------------------------------------------------------------
#
# クロスアカウント構成でAWS Network FirewallをTransit Gatewayに
# アタッチした際に作成されるTransit Gatewayアタッチメントを承認する
# リソースです。
#
# Transit Gatewayの所有者アカウントがAutoAccept無効の状態で、
# Firewallオーナーのアカウントからaws_networkfirewall_firewallを
# 使用してFirewallを作成した際に「Pending Acceptance」状態になる
# Transit GatewayアタッチメントをAcceptして管理対象に取り込みます。
# アタッチメントがAvailableになるとFirewallはReady状態になります。
#
# AWS公式ドキュメント:
#   - Transit Gateway接続ファイアウォール: https://docs.aws.amazon.com/network-firewall/latest/developerguide/tgw-firewall.html
#   - Transit Gatewayアタッチメントの承認: https://docs.aws.amazon.com/vpc/latest/tgw/accept-reject-firewall-attachment.html
#   - AcceptNetworkFirewallTransitGatewayAttachment API: https://docs.aws.amazon.com/network-firewall/latest/APIReference/API_AcceptNetworkFirewallTransitGatewayAttachment.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_transit_gateway_attachment_accepter
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkfirewall_firewall_transit_gateway_attachment_accepter" "example" {
  #-------------------------------------------------------------
  # アタッチメント識別設定
  #-------------------------------------------------------------

  # transit_gateway_attachment_id (Required)
  # 設定内容: 承認対象のTransit GatewayアタッチメントのIDを指定します。
  #           Transit Gatewayアタッチ済みFirewallを作成した際のレスポンスとして
  #           返されるIDです。
  # 設定可能な値: 有効なTransit GatewayアタッチメントID（例: tgw-attach-xxxxxxxxxxxxxxxxx）
  # 参考: aws_networkfirewall_firewallリソースのfirewall_status[0]
  #       .transit_gateway_attachment_sync_state[0].attachment_id で参照可能
  transit_gateway_attachment_id = "tgw-attach-xxxxxxxxxxxxxxxxx"

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

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "2h45m"）
    #               使用可能な単位: "s"（秒）, "m"（分）, "h"（時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "20m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "2h45m"）
    #               使用可能な単位: "s"（秒）, "m"（分）, "h"（時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    # 注意: 削除操作に対するタイムアウト設定は、destroyが実行される前に
    #       stateに変更が保存されている場合にのみ適用されます。
    delete = "20m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Transit GatewayアタッチメントのID（transit_gateway_attachment_idと同値）
#---------------------------------------------------------------
