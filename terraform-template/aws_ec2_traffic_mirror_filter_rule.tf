#-------
# AWS EC2 Traffic Mirror Filter Rule (aws_ec2_traffic_mirror_filter_rule)
#-------
# Provider Version: 6.28.0
# Generated: 2026-02-15
#
# NOTE: このテンプレートはAWS Provider 6.28.0のスキーマから生成されています。
#       実際の利用時は、プロジェクトの要件に合わせてコメントアウト部分を調整してください。
#
# 【リソース概要】
# VPC Traffic Mirroringのフィルタールールを定義します。
# トラフィックミラーリングは、ENIから送受信されるネットワークトラフィックをキャプチャし、
# セキュリティ監視や分析のために別のターゲットに送信する機能です。
# このリソースでは送信元/送信先CIDRブロック、ポート範囲、プロトコル、
# トラフィック方向（ingress/egress）を指定してミラーリング対象を制御します。
#
# 【主な用途】
# - セキュリティ監視・侵入検知システムへのトラフィック送信
# - コンプライアンス要件に基づくパケットキャプチャ
# - ネットワークトラブルシューティング・パフォーマンス分析
# - 本番環境トラフィックのテスト環境への複製
#
# 【前提リソース】
# - aws_ec2_traffic_mirror_filter（親フィルタリソース）の事前作成が必要
#
# 【Terraform公式ドキュメント】
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_traffic_mirror_filter_rule

#-------
# 基本設定
#-------
resource "aws_ec2_traffic_mirror_filter_rule" "example" {
  # 設定内容: このルールが属するトラフィックミラーフィルタのID
  # 必須項目: aws_ec2_traffic_mirror_filterリソースのIDを指定
  traffic_mirror_filter_id = "tmf-1234567890abcdef0"

  # 設定内容: ルールの評価順序を決定する番号（1〜32766）
  # 必須項目: 数値が小さいほど優先度が高く、一致した時点で評価が終了
  # 注意: 同一フィルタ内で同じ番号は使用不可
  rule_number = 100

  # 設定内容: トラフィックミラーリングの方向
  # 設定可能な値:
  #   - ingress: ENIへの受信トラフィックをミラーリング
  #   - egress: ENIからの送信トラフィックをミラーリング
  # 必須項目
  traffic_direction = "ingress"

  # 設定内容: トラフィックが条件に一致した場合のアクション
  # 設定可能な値:
  #   - accept: トラフィックをミラーリング対象に含める
  #   - reject: トラフィックをミラーリング対象から除外
  # 必須項目
  rule_action = "accept"

  # 設定内容: 送信元CIDRブロック（IPv4/IPv6対応）
  # 必須項目: すべてのIPを対象にする場合は "0.0.0.0/0" または "::/0"
  source_cidr_block = "10.0.0.0/16"

  # 設定内容: 送信先CIDRブロック（IPv4/IPv6対応）
  # 必須項目: すべてのIPを対象にする場合は "0.0.0.0/0" または "::/0"
  destination_cidr_block = "172.16.0.0/16"

  #-------
  # プロトコル・ポート設定
  #-------
  # 設定内容: ミラーリング対象のIPプロトコル番号
  # 設定可能な値:
  #   - 0-255のIANAプロトコル番号（例: 6=TCP, 17=UDP, 1=ICMP）
  #   - 省略時はすべてのプロトコルが対象
  # 省略時: すべてのプロトコル
  protocol = 6

  # 設定内容: ルールの説明（最大256文字）
  # 省略時: 説明なし
  description = "HTTPSトラフィックをミラーリング"

  #-------
  # リージョン設定
  #-------
  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-west-2"
}

#-------
# 送信元ポート範囲（オプション）
#-------
# 設定内容: ミラーリング対象の送信元ポート範囲
# 省略時: すべてのポートが対象
# 注意: TCPまたはUDP（protocol=6または17）の場合のみ有効
# resource "aws_ec2_traffic_mirror_filter_rule" "with_source_port" {
#   traffic_mirror_filter_id = "tmf-1234567890abcdef0"
#   rule_number              = 200
#   traffic_direction        = "ingress"
#   rule_action              = "accept"
#   source_cidr_block        = "10.0.0.0/16"
#   destination_cidr_block   = "0.0.0.0/0"
#   protocol                 = 6
#
#   source_port_range {
#     # 設定内容: ポート範囲の開始ポート（1〜65535）
#     # 省略時: すべての送信元ポート
#     from_port = 1024
#
#     # 設定内容: ポート範囲の終了ポート（1〜65535）
#     # 省略時: すべての送信元ポート
#     # 注意: from_portと同じ値を指定すると単一ポートを指定可能
#     to_port = 65535
#   }
# }

#-------
# 送信先ポート範囲（オプション）
#-------
# 設定内容: ミラーリング対象の送信先ポート範囲
# 省略時: すべてのポートが対象
# 注意: TCPまたはUDP（protocol=6または17）の場合のみ有効
# resource "aws_ec2_traffic_mirror_filter_rule" "with_destination_port" {
#   traffic_mirror_filter_id = "tmf-1234567890abcdef0"
#   rule_number              = 300
#   traffic_direction        = "egress"
#   rule_action              = "accept"
#   source_cidr_block        = "0.0.0.0/0"
#   destination_cidr_block   = "10.0.0.0/16"
#   protocol                 = 6
#
#   destination_port_range {
#     # 設定内容: ポート範囲の開始ポート（1〜65535）
#     # 省略時: すべての送信先ポート
#     from_port = 443
#
#     # 設定内容: ポート範囲の終了ポート（1〜65535）
#     # 省略時: すべての送信先ポート
#     # 注意: from_portと同じ値を指定すると単一ポートを指定可能
#     to_port = 443
#   }
# }

#-------
# 補足説明
#-------
# 【トラフィックミラーリングのアーキテクチャ】
# 1. ソースENI → 2. ミラーフィルタ（ルールで評価） → 3. ミラーターゲット（NLBまたはENI）
# ルールは複数定義可能で、rule_numberの昇順に評価され、最初に一致したルールが適用されます。
#
# 【rule_numberの設計パターン】
# - 10, 20, 30...（10刻み）: 後で中間にルールを追加する余地を残す推奨方式
# - 特定トラフィックを優先してacceptする場合は小さい番号を使用
# - デフォルトrejectルールは最大値（32766）に配置
#
# 【プロトコル番号の主要な値】
# - 1: ICMP（ping等）
# - 6: TCP（HTTP、HTTPS、SSH等）
# - 17: UDP（DNS、DHCP等）
# - 50: ESP（IPsec暗号化）
# - 省略: すべてのプロトコル
#
# 【IPv6対応】
# - source_cidr_blockとdestination_cidr_blockはIPv6 CIDRも指定可能
# - 例: "::/0"（すべてのIPv6）、"2001:db8::/32"（特定のIPv6範囲）
#
# 【ポート範囲の指定パターン】
# - 単一ポート: from_port = to_port = 443
# - 範囲指定: from_port = 80, to_port = 443
# - エフェメラルポート: from_port = 32768, to_port = 65535
# - すべてのポート: 両方省略、またはfrom_port = 0, to_port = 65535
#
# 【よくある設定例】
# 1. すべてのHTTPSトラフィックをミラーリング:
#    protocol = 6, destination_port_range { from_port = 443, to_port = 443 }
# 2. 特定サブネットからのすべてのトラフィック:
#    source_cidr_block = "10.0.1.0/24", destination_cidr_block = "0.0.0.0/0"
# 3. egress通信のみをミラーリング:
#    traffic_direction = "egress"
#
# 【注意事項】
# - 同一traffic_mirror_filter_id内でrule_numberは一意である必要があります
# - ルールの変更時は、ミラーリングセッションに影響を与える可能性があります
# - 大量のトラフィックをミラーリングするとソースENIのパフォーマンスに影響します
# - ミラーターゲットの処理能力を超えないよう、ルールで適切にフィルタリングしてください

#-------
# Attributes Reference（参照可能な属性）
#-------
# このリソースが作成された後、以下の属性を他のリソースやモジュールから参照できます。
#
# output "traffic_mirror_filter_rule_arn" {
#   description = "トラフィックミラーフィルタールールのARN"
#   value       = aws_ec2_traffic_mirror_filter_rule.example.arn
# }
#
# output "traffic_mirror_filter_rule_id" {
#   description = "トラフィックミラーフィルタールールのID"
#   value       = aws_ec2_traffic_mirror_filter_rule.example.id
# }
#
# output "traffic_mirror_filter_rule_region" {
#   description = "リソースが管理されているAWSリージョン"
#   value       = aws_ec2_traffic_mirror_filter_rule.example.region
# }
