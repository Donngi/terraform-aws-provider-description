#---------------------------------------------------------------
# AWS Network Manager Core Network Policy Attachment
#---------------------------------------------------------------
#
# Core NetworkにポリシーをアタッチしてLIVE状態にするリソース。
# このリソースを使用すると、Core Network Policyを既存のCore Networkにアタッチし、
# 変更セットを実行してグローバルにデプロイする（ポリシーを`LIVE`に設定）。
#
# 注意: このリソースを削除しても、現在のポリシーは削除されず、
# 以前のバージョンに戻ることもない。
#
# AWS公式ドキュメント:
#   - Core network policy versions: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-create-policy-version.html
#   - Attachment policies: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-policy-attachments.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_core_network_policy_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_core_network_policy_attachment" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # core_network_id (Required, Forces new resource)
  # ポリシーをアタッチしてLIVE状態にするCore NetworkのID。
  # aws_networkmanager_core_networkリソースのidを参照するか、
  # 既存のCore Network IDを直接指定する。
  #
  # 例: aws_networkmanager_core_network.example.id
  core_network_id = null # Required: string

  # policy_document (Required)
  # Core Networkを構成するポリシードキュメント（JSON形式）。
  # この引数を更新すると、新しいポリシードキュメントバージョンが
  # LATESTおよびLIVEポリシードキュメントとして設定される。
  #
  # 通常、data.aws_networkmanager_core_network_policy_document.json を使用して
  # ポリシードキュメントを構築する。
  #
  # ポリシードキュメントには以下の要素を含める:
  #   - core_network_configuration: ASN範囲、エッジロケーション設定
  #   - segments: ネットワークセグメント定義
  #   - attachment_policies: アタッチメントとセグメントのマッピングルール
  #   - segment_actions: セグメント間ルーティング、ルート作成等
  #
  # 例: data.aws_networkmanager_core_network_policy_document.example.json
  policy_document = null # Required: string (JSON)

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # id (Optional, Computed)
  # リソースの識別子。通常はTerraformが自動生成するため指定不要。
  # インポート時などに使用する場合がある。
  #
  # id = null # Optional: string

  #---------------------------------------------------------------
  # タイムアウト設定 (Timeouts)
  #---------------------------------------------------------------

  # timeouts ブロック
  # ポリシーアタッチメント操作のタイムアウト時間をカスタマイズする。
  # Core Networkポリシーの変更は、グローバルにデプロイされるため
  # 時間がかかる場合がある。
  #
  timeouts {
    # update (Optional)
    # ポリシーの更新操作のタイムアウト時間。
    # 大規模なポリシー変更やエッジロケーションの追加時は
    # デフォルトより長く設定することを検討する。
    #
    # 形式: "30m" (30分), "1h" (1時間) など
    # デフォルト: Terraformのデフォルト値が使用される
    #
    update = null # Optional: string (例: "30m")
  }
}

#---------------------------------------------------------------
# Attributes Reference (出力専用属性)
#---------------------------------------------------------------
# 以下の属性はTerraformにより自動的に設定され、参照可能。
# これらはリソースブロック内では設定できない。
#
# state
#   - Core Networkの現在の状態を示す。
#   - 例: "AVAILABLE", "PENDING", "UPDATING" など
#   - 参照: aws_networkmanager_core_network_policy_attachment.this.state
#

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# 基本的な使用例:
#
# # グローバルネットワークの作成
# resource "aws_networkmanager_global_network" "example" {}
#
# # ベースポリシードキュメント（Core Network作成時用）
# data "aws_networkmanager_core_network_policy_document" "base" {
#   core_network_configuration {
#     asn_ranges = ["65022-65534"]
#     edge_locations {
#       location = "us-west-2"
#       asn      = "65500"
#     }
#   }
#   segments {
#     name = "segment"
#   }
# }
#
# # Core Networkの作成
# resource "aws_networkmanager_core_network" "example" {
#   global_network_id    = aws_networkmanager_global_network.example.id
#   base_policy_document = data.aws_networkmanager_core_network_policy_document.base.json
#   create_base_policy   = true
# }
#
# # 実際のポリシードキュメント
# data "aws_networkmanager_core_network_policy_document" "example" {
#   core_network_configuration {
#     asn_ranges = ["65022-65534"]
#     edge_locations {
#       location = "us-west-2"
#       asn      = "65500"
#     }
#   }
#   segments {
#     name = "segment"
#   }
#   segment_actions {
#     action  = "create-route"
#     segment = "segment"
#     destination_cidr_blocks = ["0.0.0.0/0"]
#     destinations = [
#       aws_networkmanager_vpc_attachment.example.id,
#     ]
#   }
# }
#
# # ポリシーアタッチメント
# resource "aws_networkmanager_core_network_policy_attachment" "example" {
#   core_network_id = aws_networkmanager_core_network.example.id
#   policy_document = data.aws_networkmanager_core_network_policy_document.example.json
# }
#
#---------------------------------------------------------------
# インポート
#---------------------------------------------------------------
#
# 既存のCore Network Policy Attachmentをインポートする場合:
#
# terraform import aws_networkmanager_core_network_policy_attachment.example core-network-0d47f6t230mz46dy4
#
# ※ core-network-0d47f6t230mz46dy4 はCore Network IDを指定
#
