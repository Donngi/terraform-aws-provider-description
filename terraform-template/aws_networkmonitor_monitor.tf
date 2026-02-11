#---------------------------------------------------------------
# Amazon CloudWatch Network Monitor - Monitor
#---------------------------------------------------------------
#
# Amazon CloudWatch Network Monitor のモニターリソースをプロビジョニングします。
# Network Monitor（Synthetic Monitor）は、ハイブリッドネットワーク接続の
# レイテンシーとパケットロスを追跡・可視化するためのマネージドエージェントを使用した
# 能動的なネットワーク監視サービスです。
#
# AWS公式ドキュメント:
#   - Amazon CloudWatch Network Monitoring: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Network-Monitoring-Sections.html
#   - API Reference: https://docs.aws.amazon.com/networkmonitor/latest/APIReference/index.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmonitor_monitor
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmonitor_monitor" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # monitor_name (必須, string)
  # モニターの名前を指定します。
  # この名前はモニターを一意に識別するために使用されます。
  monitor_name = "example-monitor"

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # aggregation_period (オプション, number)
  # メトリクスの集約期間（秒単位）を指定します。
  # 指定可能な値: 30 または 60（秒）
  # デフォルト: 60
  # この値は、モニターがメトリクスデータを集約する時間間隔を決定します。
  # 30秒を指定すると、より細かい粒度でメトリクスを取得できますが、
  # 60秒を指定すると、より長い期間での平均値が計算されます。
  aggregation_period = 60

  # region (オプション, string)
  # このリソースを管理するAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  # tags (オプション, map(string))
  # リソースに割り当てるタグのマップを指定します。
  # タグはリソースの整理、コスト配分、アクセス制御などに使用できます。
  # Provider の default_tags 設定と組み合わせて使用することで、
  # 共通タグを効率的に管理できます。
  tags = {
    Name        = "example-network-monitor"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (参照専用属性)
#---------------------------------------------------------------
# 以下の属性はTerraformによって自動的に設定され、参照のみ可能です。
# これらは terraform state show や output で確認できます。
#
# arn (string)
#   モニターのAmazon Resource Name (ARN)。
#   形式: arn:aws:networkmonitor:<region>:<account-id>:monitor/<monitor-name>
#
# id (string)
#   モニターの識別子。monitor_name と同じ値になります。
#
# tags_all (map(string))
#   リソースに割り当てられたすべてのタグのマップ。
#   Provider の default_tags 設定で定義されたタグを含みます。
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 基本的なモニター作成
#---------------------------------------------------------------
# resource "aws_networkmonitor_monitor" "basic" {
#   aggregation_period = 30
#   monitor_name       = "basic-monitor"
# }

#---------------------------------------------------------------
# 使用例: プローブと組み合わせたモニター
#---------------------------------------------------------------
# モニターを作成した後、aws_networkmonitor_probe リソースを使用して
# プローブを追加し、特定のエンドポイントへの接続を監視できます。
#
# resource "aws_networkmonitor_monitor" "with_probe" {
#   aggregation_period = 30
#   monitor_name       = "hybrid-network-monitor"
#
#   tags = {
#     Purpose = "Hybrid Network Monitoring"
#   }
# }
#
# resource "aws_networkmonitor_probe" "example" {
#   monitor_name = aws_networkmonitor_monitor.with_probe.monitor_name
#   # プローブの設定は aws_networkmonitor_probe リソースを参照
# }
