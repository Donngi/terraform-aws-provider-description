#---------------------------------------------------------------
# AWS Network Manager Direct Connect Gateway Attachment
#---------------------------------------------------------------
#
# AWS Cloud WAN と Direct Connect ゲートウェイを直接接続するためのアタッチメントリソース。
# 従来は Transit Gateway を介して接続する必要があったが、このリソースにより
# Direct Connect ゲートウェイを Cloud WAN コアネットワークに直接アタッチできる。
# オンプレミスネットワークと AWS VPC 間のシームレスな接続を実現し、
# BGP による自動ルート伝播をサポートする。
#
# AWS公式ドキュメント:
#   - Direct Connect gateway attachments in AWS Cloud WAN:
#     https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-dxattach-about.html
#   - Create a Direct Connect gateway attachment:
#     https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-dxattachment-add.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_dx_gateway_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_dx_gateway_attachment" "example" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # core_network_id (必須, 文字列)
  # Direct Connect ゲートウェイアタッチメントを接続する Cloud WAN コアネットワークの ID。
  # aws_networkmanager_core_network_policy_attachment リソースの core_network_id を参照することを推奨。
  # コアネットワークポリシーがアタッチされた後にアタッチメントを作成する必要がある。
  core_network_id = "core-network-1234567890abcdef0"

  # direct_connect_gateway_arn (必須, 文字列)
  # アタッチする Direct Connect ゲートウェイの ARN。
  # 形式: arn:aws:directconnect::<アカウントID>:dx-gateway/<Direct Connectゲートウェイ ID>
  # 注意:
  #   - 1つの Direct Connect ゲートウェイは1つのコアネットワークにのみ関連付け可能
  #   - Direct Connect ゲートウェイの ASN はコアネットワークの ASN 範囲外である必要がある
  #   - 既にトランジットゲートウェイやバーチャルゲートウェイに関連付けられている
  #     Direct Connect ゲートウェイは使用不可
  direct_connect_gateway_arn = "arn:aws:directconnect::123456789012:dx-gateway/abcd1234-ab12-ab12-ab12-abcdef123456"

  # edge_locations (必須, 文字列のリスト)
  # Direct Connect ゲートウェイアタッチメントに関連付けるコアネットワークエッジロケーション。
  # 1つ以上のリージョンを指定する必要がある。
  # 指定したエッジロケーションがオンプレミスネットワークとの接続ポイントとなる。
  # 各エッジロケーションはローカルルートのみを Direct Connect ゲートウェイに広告する。
  edge_locations = [
    "us-east-1",
    "us-west-2",
  ]

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # routing_policy_label (オプション, 文字列)
  # トラフィックルーティング決定のためにアタッチメントに適用するルーティングポリシーラベル。
  # コアネットワークポリシーでルーティングルールを定義し、このラベルでマッピングできる。
  # 最大256文字。
  # 注意: この値を変更するとリソースが再作成される（ForceNew）。
  # routing_policy_label = "production-routes"

  # tags (オプション, 文字列のマップ)
  # アタッチメントに割り当てるタグのキーバリューマップ。
  # プロバイダーレベルで default_tags が設定されている場合、
  # 同じキーを持つタグはプロバイダーレベルの設定を上書きする。
  # tags = {
  #   Name        = "prod-dx-attachment"
  #   Environment = "production"
  #   Project     = "network-infrastructure"
  # }

  #---------------------------------------------------------------
  # タイムアウト設定 (Timeouts)
  #---------------------------------------------------------------
  # Direct Connect ゲートウェイアタッチメントの作成・更新・削除操作のタイムアウト。
  # 大規模なネットワーク構成では、デフォルトのタイムアウトでは不十分な場合がある。

  # timeouts {
  #   # create (オプション, 文字列)
  #   # リソース作成のタイムアウト。デフォルトは10分。
  #   # Direct Connect ゲートウェイの状態遷移に時間がかかる場合に延長する。
  #   # 形式: 数値と単位の組み合わせ（例: "30s", "5m", "1h"）
  #   # 有効な単位: "s"（秒）, "m"（分）, "h"（時間）
  #   create = "30m"
  #
  #   # update (オプション, 文字列)
  #   # リソース更新のタイムアウト。デフォルトは10分。
  #   # エッジロケーションの変更など、更新操作に時間がかかる場合に延長する。
  #   # 形式: 数値と単位の組み合わせ（例: "30s", "5m", "1h"）
  #   # 有効な単位: "s"（秒）, "m"（分）, "h"（時間）
  #   update = "30m"
  #
  #   # delete (オプション, 文字列)
  #   # リソース削除のタイムアウト。デフォルトは10分。
  #   # アタッチメントのデタッチに時間がかかる場合に延長する。
  #   # 形式: 数値と単位の組み合わせ（例: "30s", "5m", "1h"）
  #   # 有効な単位: "s"（秒）, "m"（分）, "h"（時間）
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートする（terraform state や output で参照可能）:
#
# arn (文字列)
#   アタッチメントの ARN。
#   形式: arn:aws:networkmanager::<アカウントID>:attachment/<アタッチメント ID>
#
# id (文字列)
#   アタッチメントの ID。ARN の末尾部分と同一。
#
# attachment_policy_rule_number (数値)
#   アタッチメントに関連付けられたポリシールール番号。
#   コアネットワークポリシーで定義されたルールに基づく。
#
# attachment_type (文字列)
#   アタッチメントのタイプ。このリソースでは "DIRECT_CONNECT_GATEWAY"。
#
# core_network_arn (文字列)
#   アタッチメントが接続されているコアネットワークの ARN。
#
# owner_account_id (文字列)
#   アタッチメント所有者の AWS アカウント ID。
#
# segment_name (文字列)
#   アタッチメントが属するセグメント名。
#   コアネットワークポリシーで定義されたセグメントに基づく。
#
# state (文字列)
#   アタッチメントの状態。
#   可能な値: CREATING, AVAILABLE, PENDING_NETWORK_UPDATE, PENDING_TAG_ACCEPTANCE,
#            PENDING_ATTACHMENT_ACCEPTANCE, UPDATING, DELETING, FAILED, REJECTED
#
# tags_all (文字列のマップ)
#   プロバイダーの default_tags を含む、リソースに割り当てられた全タグのマップ。
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
# 以下は完全な構成例を示す。

# # 現在のアカウント情報を取得
# data "aws_caller_identity" "current" {}
#
# # 現在のリージョンを取得
# data "aws_region" "current" {}
#
# # Direct Connect ゲートウェイ（別途作成済みを想定）
# # data "aws_dx_gateway" "existing" {
# #   name = "my-dx-gateway"
# # }
#
# # コアネットワークの参照
# # resource "aws_networkmanager_core_network_policy_attachment" "example" {
# #   core_network_id = aws_networkmanager_core_network.example.id
# #   policy_document = data.aws_networkmanager_core_network_policy_document.example.json
# # }
#
# # Direct Connect ゲートウェイアタッチメントの作成
# resource "aws_networkmanager_dx_gateway_attachment" "production" {
#   core_network_id            = aws_networkmanager_core_network_policy_attachment.example.core_network_id
#   direct_connect_gateway_arn = "arn:aws:directconnect::${data.aws_caller_identity.current.account_id}:dx-gateway/${aws_dx_gateway.example.id}"
#   edge_locations             = [data.aws_region.current.region]
#
#   routing_policy_label = "production"
#
#   tags = {
#     Name        = "production-dx-attachment"
#     Environment = "production"
#   }
# }

#---------------------------------------------------------------
# 重要な考慮事項
#---------------------------------------------------------------
#
# 1. 前提条件:
#    - Direct Connect アカウントと有効な Direct Connect ゲートウェイが必要
#    - Direct Connect ゲートウェイは1つのコアネットワークにのみ関連付け可能
#    - Direct Connect ゲートウェイの ASN はコアネットワークの ASN 範囲外である必要がある
#
# 2. 制限事項:
#    - コアネットワークポリシーで Direct Connect ゲートウェイアタッチメントを
#      next hop として静的ルートを設定することはできない
#    - Direct Connect BGP コミュニティは Cloud WAN ネットワークでサポートされていない
#    - Cloud WAN からオンプレミスへの許可プレフィックスリストの設定は不可
#    - Private IP VPN および Connect アタッチメントは、
#      Direct Connect ゲートウェイアタッチメントがトランスポートタイプの場合はサポートされない
#
# 3. ルート伝播:
#    - インバウンド: オンプレミスからの BGP ルートは、関連付けられた
#      コアネットワークエッジのセグメントルートテーブルで学習される
#    - アウトバウンド: 各コアネットワークエッジはローカルルートのみを
#      Direct Connect ゲートウェイに広告する
#    - AS_PATH BGP 属性はオンプレミスへのルート広告で保持される
#
# 4. 料金:
#    - 時間単位の課金とデータ転送量（GB）単位の課金が発生
#    - 詳細: https://aws.amazon.com/cloud-wan/pricing/
#
#---------------------------------------------------------------
