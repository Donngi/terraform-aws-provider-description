#---------------------------------------------------------------
# AWS Network Manager Core Network Policy Attachment
#---------------------------------------------------------------
#
# AWS Cloud WANのコアネットワークにポリシードキュメントを添付し、
# 変更セットを実行してポリシーをグローバルにデプロイするリソースです。
# ポリシーを添付することでコアネットワークの状態がLIVEになります。
#
# AWS公式ドキュメント:
#   - コアネットワークポリシーの作成と管理: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-core-network-policy.html
#   - ポリシー変更セットの編集とデプロイ: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-policy-change-sets.html
#   - コアネットワークポリシーのパラメータ: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-policies-json.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_core_network_policy_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_core_network_policy_attachment" "example" {
  #-------------------------------------------------------------
  # コアネットワーク設定
  #-------------------------------------------------------------

  # core_network_id (Required)
  # 設定内容: ポリシーを添付してLIVE状態にするコアネットワークのIDを指定します。
  # 設定可能な値: 有効なコアネットワークID（例: core-network-0a1b2c3d4e5f67890）
  # 参考: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-core-network-policy.html
  core_network_id = "core-network-0a1b2c3d4e5f67890"

  #-------------------------------------------------------------
  # ポリシードキュメント設定
  #-------------------------------------------------------------

  # policy_document (Required)
  # 設定内容: コアネットワークに適用するポリシードキュメントをJSON形式で指定します。
  #   ポリシードキュメントには以下のセクションが含まれます:
  #   - version: ポリシーバージョン（"2021.12" または "2025.11"）
  #   - core-network-configuration: リージョン・ASNレンジ・エッジロケーションの設定
  #   - segments: ネットワークセグメントの定義
  #   - segment-actions: セグメント間ルーティングの設定
  #   - attachment-policies: アタッチメントのセグメントへのマッピング設定
  # 設定可能な値: 有効なJSONポリシードキュメント文字列
  # 注意: この引数を更新すると、新しいポリシードキュメントバージョンがLATESTおよびLIVEとして設定されます。
  # 参考: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-policies-json.html
  policy_document = data.aws_networkmanager_core_network_policy_document.example.json

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # update (Optional)
    # 設定内容: リソースの更新操作がタイムアウトするまでの時間を指定します。
    # 設定可能な値: Goのtime.Durationフォーマット（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウト値を使用
    update = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: コアネットワークのID（core_network_idと同じ値）
#
# - state: コアネットワークの現在の状態
#          （例: AVAILABLE, CREATING, UPDATING, DELETING）
#---------------------------------------------------------------
