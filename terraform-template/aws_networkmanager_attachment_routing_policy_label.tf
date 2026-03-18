#---------------------------------------------------------------
# AWS Network Manager Attachment Routing Policy Label
#---------------------------------------------------------------
#
# AWS Network Managerのアタッチメントにルーティングポリシーラベルを関連付けます。
# アタッチメント作成外でルーティングポリシーラベルを適用するためのリソースです。
# マルチアカウント環境で、Cloud WANコアネットワーク所有者アカウントのみが
# ルーティングポリシーラベルを適用できる場合に使用します。
#
# AWS公式ドキュメント:
#   - AWS Cloud WAN: https://docs.aws.amazon.com/vpc/latest/cloudwan/what-is-cloudwan.html
#   - Core Network Attachments: https://docs.aws.amazon.com/vpc/latest/cloudwan/cloudwan-attachments.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_attachment_routing_policy_label
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_attachment_routing_policy_label" "example" {
  #-------------------------------------------------------------
  # コアネットワーク・アタッチメント設定
  #-------------------------------------------------------------

  # core_network_id (Required, Forces new resource)
  # 設定内容: アタッチメントが所属するコアネットワークのIDを指定します。
  # 設定可能な値: 有効なCloud WANコアネットワークのID
  # 省略時: 省略不可
  core_network_id = aws_networkmanager_core_network.example.id

  # attachment_id (Required, Forces new resource)
  # 設定内容: ルーティングポリシーラベルを適用するアタッチメントのIDを指定します。
  # 設定可能な値: 有効なNetwork Managerアタッチメントのリソース固有ID
  # 省略時: 省略不可
  # 関連機能: VPCアタッチメント、VPNアタッチメント、Connectアタッチメント、
  #   Transit Gatewayルートテーブルアタッチメント等のIDを指定します。
  attachment_id = aws_networkmanager_vpc_attachment.example.id

  # routing_policy_label (Required, Forces new resource)
  # 設定内容: アタッチメントに適用するルーティングポリシーラベルを指定します。
  # 設定可能な値: コアネットワークポリシーで定義されたラベル名の文字列
  # 省略時: 省略不可
  # 関連機能: コアネットワークポリシーのattachment-policiesセクションで
  #   定義されたラベルと一致させる必要があります。
  routing_policy_label = "attachmentPolicyLabel"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - core_network_id: コアネットワークのID
#
# - attachment_id: アタッチメントのID
#
# - routing_policy_label: 適用されたルーティングポリシーラベル
#---------------------------------------------------------------
