#---------------------------------------------------------------
# AWS Network Manager Site-to-Site VPN Attachment
#---------------------------------------------------------------
#
# AWS Cloud WANのコアネットワークにSite-to-Site VPN接続をアタッチするリソース。
# オンプレミス環境とAWS Cloud WANを接続し、グローバルネットワーク経由での
# 通信を実現する。VPN接続はカスタマーゲートウェイと組み合わせて使用し、
# IPsecトンネル経由で安全な接続を確立する。
#
# AWS公式ドキュメント:
#   - What is AWS Cloud WAN?: https://docs.aws.amazon.com/network-manager/latest/cloudwan/what-is-cloudwan.html
#   - AWS Cloud WAN User Guide: https://docs.aws.amazon.com/network-manager/latest/cloudwan/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_site_to_site_vpn_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_site_to_site_vpn_attachment" "this" {
  #---------------------------------------------------------------
  # Required Arguments（必須引数）
  #---------------------------------------------------------------

  # core_network_id (Required, string)
  # VPNアタッチメントを接続するコアネットワークのID。
  # AWS Cloud WANのコアネットワークは、グローバルネットワーク内で管理される
  # 中央のルーティングハブとして機能する。
  # 例: "core-network-0123456789abcdef0"
  core_network_id = null  # Required

  # vpn_connection_arn (Required, string)
  # アタッチするSite-to-Site VPN接続のARN。
  # aws_vpn_connectionリソースで作成したVPN接続を指定する。
  # VPN接続はCloud WANにアタッチする前に作成済みである必要がある。
  # 例: "arn:aws:ec2:us-east-1:123456789012:vpn-connection/vpn-0123456789abcdef0"
  vpn_connection_arn = null  # Required

  #---------------------------------------------------------------
  # Optional Arguments（任意引数）
  #---------------------------------------------------------------

  # routing_policy_label (Optional, string)
  # トラフィックルーティングの決定に使用するルーティングポリシーラベル。
  # コアネットワークポリシーでのルーティング制御に利用される。
  # 最大256文字まで指定可能。
  # 注意: この値を変更するとリソースが再作成される（ForceNew）。
  # 例: "production-traffic", "backup-route"
  # routing_policy_label = null

  # tags (Optional, map(string))
  # リソースに付与するタグのマップ。
  # プロバイダーレベルでdefault_tagsが設定されている場合、
  # 同じキーのタグはこちらの値で上書きされる。
  # コアネットワークポリシーでattachment_policiesを使用する場合、
  # タグベースでセグメントへの自動マッピングが可能。
  # 例: { Name = "vpn-attachment-prod", Environment = "production", segment = "shared" }
  # tags = {}

  #---------------------------------------------------------------
  # Timeouts Configuration（タイムアウト設定）
  #---------------------------------------------------------------

  # timeouts (Optional, Block)
  # 各操作のタイムアウト時間を設定する。
  # VPNアタッチメントの作成・更新・削除には時間がかかる場合があるため、
  # 必要に応じてデフォルト値を調整する。

  # timeouts {
  #   # create (Optional, string)
  #   # リソース作成時のタイムアウト。
  #   # VPNアタッチメントがPENDING_ATTACHMENT_ACCEPTANCE状態になるまで待機する。
  #   # 例: "30m", "1h"
  #   # create = null
  #
  #   # update (Optional, string)
  #   # リソース更新時のタイムアウト。
  #   # タグの更新等の操作に適用される。
  #   # 例: "30m", "1h"
  #   # update = null
  #
  #   # delete (Optional, string)
  #   # リソース削除時のタイムアウト。
  #   # アタッチメントがコアネットワークから完全に削除されるまで待機する。
  #   # 例: "30m", "1h"
  #   # delete = null
  # }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能（直接設定不可）:
#
# arn                          - アタッチメントのARN
#                                例: "arn:aws:networkmanager::123456789012:attachment/attachment-0123456789abcdef0"
#
# attachment_policy_rule_number - アタッチメントに関連付けられたポリシールール番号
#                                 コアネットワークポリシーのattachment_policiesで
#                                 定義されたrule_numberに対応
#
# attachment_type               - アタッチメントのタイプ
#                                 Site-to-Site VPNの場合は "SITE_TO_SITE_VPN"
#
# core_network_arn             - コアネットワークのARN
#
# edge_location                - エッジが配置されているリージョン
#                                VPN接続のリージョンに対応するコアネットワークエッジ
#                                例: "us-east-1", "ap-northeast-1"
#
# id                           - アタッチメントのID
#                                例: "attachment-0123456789abcdef0"
#
# owner_account_id             - アタッチメント所有者のAWSアカウントID
#
# resource_arn                 - アタッチメントリソースのARN
#                                （vpn_connection_arnと同じ値）
#
# segment_name                 - アタッチメントが所属するセグメント名
#                                コアネットワークポリシーで定義されたセグメントに
#                                自動または手動でマッピングされる
#
# state                        - アタッチメントの状態
#                                "CREATING", "PENDING_ATTACHMENT_ACCEPTANCE",
#                                "AVAILABLE", "DELETING", "FAILED" など
#
# tags_all                     - プロバイダーのdefault_tagsを含む全てのタグ
#---------------------------------------------------------------

#---------------------------------------------------------------
# Usage Example（使用例）
#---------------------------------------------------------------
#
# # 1. 基本的な使用例
# resource "aws_networkmanager_site_to_site_vpn_attachment" "basic" {
#   core_network_id    = awscc_networkmanager_core_network.main.id
#   vpn_connection_arn = aws_vpn_connection.main.arn
# }
#
# # 2. タグベースのセグメントマッピングを使用した例
# resource "aws_networkmanager_site_to_site_vpn_attachment" "with_segment" {
#   core_network_id    = awscc_networkmanager_core_network.main.id
#   vpn_connection_arn = aws_vpn_connection.branch_office.arn
#
#   tags = {
#     Name    = "branch-office-vpn"
#     segment = "shared"  # コアネットワークポリシーで定義されたセグメントにマッピング
#   }
# }
#
# # 3. VPNアタッチメントの承認（require_attachment_acceptance = true の場合）
# resource "aws_networkmanager_attachment_accepter" "vpn" {
#   attachment_id   = aws_networkmanager_site_to_site_vpn_attachment.with_segment.id
#   attachment_type = aws_networkmanager_site_to_site_vpn_attachment.with_segment.attachment_type
# }
#
# # 4. 関連リソースの構成例
# resource "aws_customer_gateway" "branch" {
#   bgp_asn    = 65000
#   ip_address = "203.0.113.1"  # オンプレミスVPNデバイスのパブリックIP
#   type       = "ipsec.1"
#
#   tags = {
#     Name = "branch-office-cgw"
#   }
# }
#
# resource "aws_vpn_connection" "branch" {
#   customer_gateway_id = aws_customer_gateway.branch.id
#   type                = "ipsec.1"
#   # transit_gateway_idは指定しない（Cloud WANで管理）
#
#   tags = {
#     Name = "branch-office-vpn"
#   }
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# Notes（注意事項）
#---------------------------------------------------------------
#
# 1. 前提条件:
#    - コアネットワークが作成済みであること
#    - VPN接続が作成済みであること
#    - コアネットワークポリシーでVPN接続のリージョンがエッジロケーションとして
#      定義されていること
#
# 2. コアネットワークポリシーとの連携:
#    - attachment_policiesでタグベースの自動セグメントマッピングが可能
#    - require_attachment_acceptance = true の場合、
#      aws_networkmanager_attachment_accepterで明示的な承認が必要
#
# 3. VPN接続の制約:
#    - VPN接続はTransit Gatewayにアタッチされていない状態である必要がある
#    - Cloud WANにアタッチすると、Cloud WANがVPN接続を管理する
#
# 4. ルーティング:
#    - VPN側で学習したルートはコアネットワークに伝播される
#    - コアネットワークのルートはVPN接続経由でオンプレミスに広告される
#    - セグメント間のルート共有はsegment_actionsで制御
#
# 5. BGP設定:
#    - カスタマーゲートウェイでBGP ASNを設定
#    - コアネットワークのASN範囲はコアネットワークポリシーで定義
#
#---------------------------------------------------------------
