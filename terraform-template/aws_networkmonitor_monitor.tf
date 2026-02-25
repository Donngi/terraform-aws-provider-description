#---------------------------------------------------------------
# AWS Network Monitor Monitor
#---------------------------------------------------------------
#
# Amazon CloudWatch Network Monitor（Network Synthetic Monitor）の
# モニターをプロビジョニングするリソースです。
# モニターは、AWSホスト環境からオンプレミス宛先へのネットワーク接続の
# パフォーマンスを監視し、パケットロスやレイテンシーのメトリクスを
# CloudWatch Metricsに公開します。
#
# AWS公式ドキュメント:
#   - Network Synthetic Monitor概要: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/what-is-network-monitor.html
#   - Network Monitor APIリファレンス: https://docs.aws.amazon.com/networkmonitor/latest/APIReference/index.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmonitor_monitor
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmonitor_monitor" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # monitor_name (Required)
  # 設定内容: モニターの名前を指定します。
  # 設定可能な値: 1-255文字の文字列。英数字、ハイフン、アンダースコアが使用可能
  # 注意: 作成後は変更不可（変更するには新しいモニターを作成する必要があります）
  monitor_name = "example-monitor"

  #-------------------------------------------------------------
  # メトリクス集計設定
  #-------------------------------------------------------------

  # aggregation_period (Optional)
  # 設定内容: モニターがメトリクスを集計する間隔を秒単位で指定します。
  # 設定可能な値:
  #   - 30: 30秒間隔（推奨）
  #   - 60: 60秒間隔
  # 省略時: AWSがデフォルト値（30秒）を使用します。
  # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/what-is-network-monitor.html
  aggregation_period = 30

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-monitor"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: モニターのAmazon Resource Name (ARN)
#
# - id: モニターの識別子（monitor_nameと同じ値）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
