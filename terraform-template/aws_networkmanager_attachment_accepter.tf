#---------------------------------------------------------------
# AWS Network Manager Attachment Accepter
#---------------------------------------------------------------
#
# AWS Network Managerのクロスアカウントアタッチメントを承認します。
# アタッチメントが別アカウントで作成され、コアネットワークの所有アカウントが
# 承認する必要がある場合に使用します。
# VPCアタッチメント、Site-to-Site VPNアタッチメント、Connectアタッチメント、
# Transit Gatewayルートテーブルアタッチメント、Direct Connect Gatewayアタッチメント
# などの承認に対応しています。
#
# AWS公式ドキュメント:
#   - AWS Cloud WAN: https://docs.aws.amazon.com/vpc/latest/cloudwan/what-is-cloudwan.html
#   - Core Network Attachments: https://docs.aws.amazon.com/vpc/latest/cloudwan/cloudwan-attachments.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_attachment_accepter
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_attachment_accepter" "example" {
  #-------------------------------------------------------------
  # アタッチメント設定
  #-------------------------------------------------------------

  # attachment_id (Required)
  # 設定内容: 承認対象のアタッチメントIDを指定します。
  # 設定可能な値: 有効なNetwork Managerアタッチメントのリソース固有ID
  # 省略時: 省略不可
  # 関連機能: AWS Cloud WAN アタッチメント
  #   VPCアタッチメント、VPNアタッチメント、Connectアタッチメント、
  #   Transit Gatewayルートテーブルアタッチメント、Direct Connect Gatewayアタッチメント
  #   などのIDを指定します。
  attachment_id = "attachment-0123456789abcdef0"

  # attachment_type (Required)
  # 設定内容: 承認対象のアタッチメントタイプを指定します。
  # 設定可能な値:
  #   "CONNECT"                    - Connectアタッチメント
  #   "DIRECT_CONNECT_GATEWAY"     - Direct Connect Gatewayアタッチメント
  #   "SITE_TO_SITE_VPN"           - Site-to-Site VPNアタッチメント
  #   "TRANSIT_GATEWAY_ROUTE_TABLE" - Transit Gatewayルートテーブルアタッチメント
  #   "VPC"                        - VPCアタッチメント
  # 省略時: 省略不可
  attachment_type = "VPC"

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: アタッチメント承認操作のタイムアウトを指定します。
  # 設定可能な値: Go duration形式の文字列 (例: "10m", "1h")
  # 省略時: Terraformのデフォルトタイムアウトが適用されます
  timeouts {
    # create (Optional)
    # 設定内容: アタッチメント承認の作成タイムアウト時間を指定します。
    # 設定可能な値: Go duration形式の文字列 (例: "30m")
    # 省略時: Terraformのデフォルト値が適用されます
    create = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: アタッチメントのID
#
# - attachment_policy_rule_number: アタッチメントに関連付けられたポリシールール番号
#
# - core_network_arn: コアネットワークのARN
#
# - core_network_id: コアネットワークのID
#
# - edge_location: エッジのリージョン（Direct Connect Gateway以外のアタッチメントに返されます）
#
# - edge_locations: Direct Connect Gatewayが関連付けられたエッジロケーション一覧
#                   (Direct Connect Gatewayアタッチメントのみ返されます)
#
# - owner_account_id: アタッチメントのアカウントオーナーID
#
# - resource_arn: アタッチメントリソースのARN
#
# - segment_name: アタッチメントのセグメント名
#
# - state: アタッチメントの状態
#---------------------------------------------------------------
