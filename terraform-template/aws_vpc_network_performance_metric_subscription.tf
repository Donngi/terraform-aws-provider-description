#---------------------------------------------------------------
# VPC Network Performance Metric Subscription
#---------------------------------------------------------------
#
# AWS Network ManagerのInfrastructure Performance機能を使用して、
# AWSリージョン間、アベイラビリティゾーン間、またはアベイラビリティゾーン内の
# ネットワークパフォーマンスメトリクスをAmazon CloudWatchに公開するサブスクリプションを管理します。
#
# Infrastructure Performanceは、AWS環境のネットワークレイテンシーをほぼリアルタイムおよび
# 履歴データとして提供し、ネットワークパフォーマンスの評価やアプリケーションへの影響を
# 判断するために使用できます。
#
# AWS公式ドキュメント:
#   - Infrastructure Performance for AWS Network Manager: https://docs.aws.amazon.com/network-manager/latest/infrastructure-performance/what-is-nmip.html
#   - CloudWatch subscriptions for Infrastructure Performance: https://docs.aws.amazon.com/network-manager/latest/infrastructure-performance/nmip-subscriptions-cw.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/vpc_network_performance_metric_subscription
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_network_performance_metric_subscription" "example" {
  #---------------------------------------------------------------
  # ソースとデスティネーション設定
  #---------------------------------------------------------------

  # destination (Required)
  # 設定内容: メトリクスサブスクリプションの送信先となるリージョンまたはアベイラビリティゾーンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-west-1, eu-west-1）またはアベイラビリティゾーン（例: us-east-1a）
  # 関連機能: Infrastructure Performance
  #   AWS Network ManagerのInfrastructure Performance機能は、リージョン間、アベイラビリティゾーン間、
  #   またはアベイラビリティゾーン内のネットワークパフォーマンスメトリクスを提供します。
  #   - https://docs.aws.amazon.com/network-manager/latest/infrastructure-performance/what-is-nmip.html
  destination = "us-west-1"

  # source (Required)
  # 設定内容: メトリクスサブスクリプションの送信元となるリージョンまたはアベイラビリティゾーンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）またはアベイラビリティゾーン（例: us-east-1a）
  # 関連機能: Infrastructure Performance
  #   Infrastructure Performanceを使用してリージョン拡張戦略を評価できます。
  #   例えば、現在の拠点（us-west-2）と拡張予定のリージョン（eu-central-1）間の
  #   レイテンシーを確認し、適切な意思決定を行うことができます。
  #   - https://docs.aws.amazon.com/network-manager/latest/infrastructure-performance/what-is-nmip.html
  source = "us-east-1"

  #---------------------------------------------------------------
  # メトリクス設定
  #---------------------------------------------------------------

  # metric (Optional)
  # 設定内容: サブスクリプションで使用するメトリクスの種類を指定します。
  # 設定可能な値:
  #   - "aggregate-latency": 集約レイテンシーメトリクス（現在サポートされている唯一のメトリクス）
  # 省略時: "aggregate-latency"
  # 関連機能: CloudWatch subscriptions for Infrastructure Performance
  #   有効化されたサブスクリプションは、5分間隔でCloudWatchにネットワークパフォーマンスメトリクスを公開します。
  #   EC2名前空間のAggregateAWSNetworkPerformanceメトリクスとして記録されます。
  #   - https://docs.aws.amazon.com/network-manager/latest/infrastructure-performance/nmip-subscriptions-cw.html
  metric = "aggregate-latency"

  # statistic (Optional)
  # 設定内容: サブスクリプションで使用する統計値を指定します。
  # 設定可能な値:
  #   - "p50": 中央値（50パーセンタイル）のレイテンシー
  # 省略時: "p50"
  # 関連機能: Infrastructure Performance メトリクス
  #   p50統計は、5分間隔で収集された全レイテンシー測定値の中央値を表します。
  #   AWS管理のプローブによって測定された合成トラフィックの往復レイテンシーです。
  #   - https://docs.aws.amazon.com/network-manager/latest/infrastructure-performance/how-nmip-works.html
  statistic = "p50"

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #---------------------------------------------------------------
  # リソースID設定
  #---------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースのIDを指定します。
  # 省略時: Terraformが自動的に生成・管理
  # 注意: 通常は指定不要です。この属性はcomputed属性でもあり、明示的に指定しない場合は自動的に割り当てられます。
  id = null

  #---------------------------------------------------------------
  # タグ設定
  #---------------------------------------------------------------
  # NOTE: このリソースはタグをサポートしていません。
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - period: サブスクリプションのデータ集約時間
#           Infrastructure Performanceはデフォルトで5分間隔でメトリクスを公開します。
#           この値は自動的に設定され、変更することはできません。
