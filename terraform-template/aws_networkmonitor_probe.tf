#---------------------------------------------------------------
# AWS Network Monitor Probe
#---------------------------------------------------------------
#
# Amazon CloudWatch Network Synthetic Monitorのプローブリソースを作成する。
# プローブは、AWSでホストされているリソースからオンプレミスの宛先IPアドレスへ
# 送信されるトラフィックを定義し、ネットワークのパケットロスとレイテンシを
# 測定するために使用される。
#
# Network Synthetic Monitorは、ハイブリッドネットワーク接続のパフォーマンスを
# 可視化し、ネットワーク障害の原因を迅速に特定するためのフルマネージドサービス。
#
# AWS公式ドキュメント:
#   - Network Synthetic Monitor: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/what-is-network-monitor.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmonitor_probe
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmonitor_probe" "example" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # monitor_name (必須)
  # ----------------------------------------
  # プローブを関連付けるモニターの名前。
  # aws_networkmonitor_monitorリソースで作成したモニターの名前を指定する。
  #
  # 型: string
  monitor_name = aws_networkmonitor_monitor.example.monitor_name

  # destination (必須)
  # ----------------------------------------
  # プローブの宛先IPアドレス。
  # オンプレミスネットワーク内のターゲットIPアドレスを指定する。
  # IPv4およびIPv6アドレスの両方がサポートされている。
  #
  # 型: string
  destination = "10.0.0.1"

  # protocol (必須)
  # ----------------------------------------
  # プローブで使用するプロトコル。
  # 指定可能な値:
  #   - "TCP": TCPプロトコルを使用（宛先ポートの指定が必要）
  #   - "ICMP": ICMPプロトコルを使用（宛先ポートは不要）
  #
  # 型: string
  protocol = "TCP"

  # source_arn (必須)
  # ----------------------------------------
  # プローブの送信元となるAWSリソースのARN。
  # VPC内のサブネットのARNを指定する。
  # モニターと同じアカウントが所有するサブネットである必要がある。
  #
  # 型: string
  source_arn = aws_subnet.example.arn

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # destination_port (オプション)
  # ----------------------------------------
  # プローブの宛先ポート番号。
  # protocolが"TCP"の場合に指定する。
  # protocolが"ICMP"の場合は指定不要。
  #
  # 型: number
  # デフォルト: なし
  destination_port = 80

  # packet_size (オプション)
  # ----------------------------------------
  # プローブで送信するパケットのサイズ（バイト単位）。
  # パケットサイズを大きくすると、より現実的なネットワーク負荷を
  # シミュレートできるが、帯域幅の消費も増加する。
  #
  # 型: number
  # デフォルト: プロバイダーが自動設定
  packet_size = 56

  # region (オプション)
  # ----------------------------------------
  # このリソースを管理するAWSリージョン。
  # 指定しない場合、プロバイダー設定のリージョンが使用される。
  #
  # 型: string
  # デフォルト: プロバイダー設定のリージョン
  # region = "ap-northeast-1"

  # tags (オプション)
  # ----------------------------------------
  # リソースに割り当てるタグのマップ。
  # リソースの識別、コスト管理、アクセス制御に使用できる。
  #
  # 型: map(string)
  # デフォルト: なし
  tags = {
    Name        = "example-probe"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
#
# 以下の属性はリソース作成後に参照可能（設定不可）:
#
# address_family
# ----------------------------------------
# プローブの宛先のアドレスファミリー。
# 値は "IPV4" または "IPV6"。
#
# arn
# ----------------------------------------
# プローブのAmazon Resource Name (ARN)。
#
# id
# ----------------------------------------
# モニター名とプローブIDを結合した識別子。
#
# probe_id
# ----------------------------------------
# プローブの一意のID。
#
# tags_all
# ----------------------------------------
# プロバイダーのdefault_tagsで設定されたタグを含む、
# リソースに割り当てられたすべてのタグのマップ。
#
# vpc_id
# ----------------------------------------
# プローブの送信元サブネットが属するVPCのID。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 基本的なNetwork Monitorプローブの設定
#---------------------------------------------------------------
#
# # モニターの作成
# resource "aws_networkmonitor_monitor" "example" {
#   aggregation_period = 30
#   monitor_name       = "example-monitor"
# }
#
# # プローブの作成（TCP）
# resource "aws_networkmonitor_probe" "tcp_probe" {
#   monitor_name     = aws_networkmonitor_monitor.example.monitor_name
#   destination      = "10.0.0.1"
#   destination_port = 443
#   protocol         = "TCP"
#   source_arn       = aws_subnet.private.arn
#   packet_size      = 200
#
#   tags = {
#     Name = "tcp-probe-to-onprem"
#   }
# }
#
# # プローブの作成（ICMP）
# resource "aws_networkmonitor_probe" "icmp_probe" {
#   monitor_name = aws_networkmonitor_monitor.example.monitor_name
#   destination  = "10.0.0.2"
#   protocol     = "ICMP"
#   source_arn   = aws_subnet.private.arn
#
#   tags = {
#     Name = "icmp-probe-to-onprem"
#   }
# }
#
#---------------------------------------------------------------
