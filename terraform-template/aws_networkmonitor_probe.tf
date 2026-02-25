#---------------------------------------------------------------
# AWS Network Monitor Probe
#---------------------------------------------------------------
#
# Amazon CloudWatch Network Monitorのプローブをプロビジョニングするリソースです。
# プローブはネットワーク監視モニターに関連付けられ、送信元サブネットから
# 宛先IPアドレスへのネットワークトラフィックを監視します。
# TCPまたはICMPプロトコルを使用してネットワーク到達性とパフォーマンスを測定します。
#
# AWS公式ドキュメント:
#   - Network Monitor プローブ: https://docs.aws.amazon.com/networkmonitor/latest/APIReference/API_Probe.html
#   - プローブの追加: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/nw-monitor-add-probe.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmonitor_probe
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmonitor_probe" "example" {
  #-------------------------------------------------------------
  # 監視モニター設定
  #-------------------------------------------------------------

  # monitor_name (Required, Forces new resource)
  # 設定内容: このプローブを関連付けるネットワーク監視モニターの名前を指定します。
  # 設定可能な値: 既存のaws_networkmonitor_monitorのmonitor_name属性の値
  # 参考: https://docs.aws.amazon.com/networkmonitor/latest/APIReference/API_CreateProbe.html
  monitor_name = "example-monitor"

  #-------------------------------------------------------------
  # 送信元設定
  #-------------------------------------------------------------

  # source_arn (Required, Forces new resource)
  # 設定内容: プローブの送信元として使用するサブネットのARNを指定します。
  # 設定可能な値: 有効なサブネットARN（形式: arn:aws:ec2:{region}:{account-id}:subnet/{subnet-id}）
  #   - 文字列長: 最小20文字、最大2048文字
  #   - パターン: arn:.*
  # 参考: https://docs.aws.amazon.com/networkmonitor/latest/APIReference/API_Probe.html
  source_arn = "arn:aws:ec2:ap-northeast-1:123456789012:subnet/subnet-12345678"

  #-------------------------------------------------------------
  # 宛先設定
  #-------------------------------------------------------------

  # destination (Required)
  # 設定内容: プローブの宛先IPアドレスを指定します。
  # 設定可能な値: IPv4またはIPv6アドレス
  #   - 文字列長: 最小1文字、最大255文字
  # 参考: https://docs.aws.amazon.com/networkmonitor/latest/APIReference/API_Probe.html
  destination = "203.0.113.1"

  # destination_port (Optional)
  # 設定内容: プローブの宛先ポート番号を指定します。
  # 設定可能な値: 0 〜 65536の整数
  # 省略時: 指定なし（protocolがICMPの場合は不要）
  # 注意: protocolがTCPの場合は必須です。
  # 参考: https://docs.aws.amazon.com/networkmonitor/latest/APIReference/API_Probe.html
  destination_port = 80

  #-------------------------------------------------------------
  # プロトコル設定
  #-------------------------------------------------------------

  # protocol (Required)
  # 設定内容: 送信元から宛先へのネットワークトラフィックに使用するプロトコルを指定します。
  # 設定可能な値:
  #   - "TCP": TCPプロトコルを使用。destination_portの指定が必須
  #   - "ICMP": ICMPプロトコルを使用。destination_portは不要
  # 参考: https://docs.aws.amazon.com/networkmonitor/latest/APIReference/API_Probe.html
  protocol = "TCP"

  #-------------------------------------------------------------
  # パケット設定
  #-------------------------------------------------------------

  # packet_size (Optional)
  # 設定内容: 送信元から宛先へ送信するパケットのサイズ（バイト）を指定します。
  # 設定可能な値: 56 〜 8500の整数
  # 省略時: AWSがデフォルト値を設定
  # 参考: https://docs.aws.amazon.com/networkmonitor/latest/APIReference/API_Probe.html
  packet_size = 56

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  #   - キー長: 最小1文字、最大128文字
  #   - 値長: 最小0文字、最大256文字
  #   - タグ数: 最大200件
  # 省略時: タグなし
  # 参考: https://docs.aws.amazon.com/networkmonitor/latest/APIReference/API_Probe.html
  tags = {
    Name        = "example-probe"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - address_family: プローブのIPアドレスファミリー（IPV4またはIPV6）
# - arn:           プローブのAmazon Resource Name (ARN)
# - id:            プローブのID
# - probe_id:      プローブの一意識別子
# - tags_all:      プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#                  リソースに割り当てられたすべてのタグのマップ
# - vpc_id:        送信元サブネットのVPC ID
#---------------------------------------------------------------
