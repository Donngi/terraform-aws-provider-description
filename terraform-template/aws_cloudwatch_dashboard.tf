#---------------------------------------------------------------
# AWS CloudWatch Dashboard
#---------------------------------------------------------------
#
# Amazon CloudWatch Dashboardをプロビジョニングするリソースです。
# ダッシュボードは、AWSリソースのメトリクス、ログ、アラームを
# 視覚化するためのカスタマイズ可能なホームページを提供します。
# ウィジェットを配置してメトリクスグラフ、テキスト、アラーム状態などを
# 一元的に監視できます。
#
# AWS公式ドキュメント:
#   - CloudWatch Dashboards: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Dashboards.html
#   - Dashboard Body Structure: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/CloudWatch-Dashboard-Body-Structure.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_dashboard
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_dashboard" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # dashboard_name (Required)
  # 設定内容: ダッシュボードの名前を指定します。
  # 設定可能な値: 文字列（ダッシュボードを一意に識別する名前）
  # 注意: 同じ名前のダッシュボードが既に存在する場合は上書きされます。
  dashboard_name = "my-application-dashboard"

  # dashboard_body (Required)
  # 設定内容: ダッシュボードの詳細情報（ウィジェットの構成と配置）をJSON形式で指定します。
  # 設定可能な値: 有効なダッシュボードボディJSON文字列
  # 関連機能: CloudWatch Dashboard Body Structure
  #   ダッシュボードのJSON構造は、widgetsアレイとオプションのvariablesアレイで構成されます。
  #   各ウィジェットには type, x, y, width, height, properties を指定します。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/CloudWatch-Dashboard-Body-Structure.html
  #
  # ウィジェットタイプ:
  #   - "metric": メトリクスグラフウィジェット
  #   - "text": Markdownテキストウィジェット
  #   - "log": CloudWatch Logs Insightsクエリ結果ウィジェット
  #   - "alarm": アラーム状態ウィジェット
  #   - "explorer": メトリクスエクスプローラーウィジェット
  #   - "custom": カスタムウィジェット（Lambda関数を使用）
  #
  # 座標系:
  #   - x: 左端からの位置（0-23）
  #   - y: 上端からの位置
  #   - width: ウィジェットの幅（最大24）
  #   - height: ウィジェットの高さ
  #
  dashboard_body = jsonencode({
    widgets = [
      # メトリクスウィジェット例
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", "i-0123456789abcdef0"]
          ]
          period = 300
          stat   = "Average"
          region = "ap-northeast-1"
          title  = "EC2 CPU Utilization"
        }
      },
      # テキストウィジェット例
      {
        type   = "text"
        x      = 12
        y      = 0
        width  = 12
        height = 3
        properties = {
          markdown = "# Application Dashboard\nThis dashboard monitors key metrics for the application."
        }
      },
      # アラーム状態ウィジェット例
      {
        type   = "alarm"
        x      = 0
        y      = 6
        width  = 12
        height = 3
        properties = {
          title  = "Alarm Status"
          alarms = [
            "arn:aws:cloudwatch:ap-northeast-1:123456789012:alarm:HighCPUAlarm"
          ]
        }
      }
    ]
  })

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: CloudWatch Dashboardはグローバルリソースとして扱われますが、
  #       ダッシュボード内のウィジェットは各メトリクスのリージョンを個別に指定できます。
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - dashboard_arn: ダッシュボードのAmazon Resource Name (ARN)
#
#---------------------------------------------------------------
