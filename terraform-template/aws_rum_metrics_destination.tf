#---------------------------------------------------------------
# AWS CloudWatch RUM Metrics Destination
#---------------------------------------------------------------
#
# Amazon CloudWatch RUM（Real User Monitoring）のアプリモニターが
# 拡張メトリクスを送信する送信先を作成・更新するリソースです。
# 送信先として CloudWatch または CloudWatch Evidently を指定できます。
# Evidently を送信先とする場合は、実験のARNとIAMロールARNの指定が必要です。
#
# AWS公式ドキュメント:
#   - CloudWatch RUM メトリクス送信先: https://docs.aws.amazon.com/cloudwatchrum/latest/APIReference/API_PutRumMetricsDestination.html
#   - カスタムメトリクスと拡張メトリクス: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-RUM-custom-and-extended-metrics.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rum_metrics_destination
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rum_metrics_destination" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # app_monitor_name (Required)
  # 設定内容: メトリクスを送信するCloudWatch RUMアプリモニターの名前を指定します。
  # 設定可能な値: 有効なCloudWatch RUMアプリモニター名
  app_monitor_name = "example-app-monitor"

  # destination (Required)
  # 設定内容: メトリクスの送信先を指定します。
  # 設定可能な値:
  #   - "CloudWatch": Amazon CloudWatchにメトリクスを送信します
  #   - "Evidently": Amazon CloudWatch Evidentlyの実験にメトリクスを送信します。
  #                  この場合、destination_arn と iam_role_arn の指定も必要です。
  destination = "CloudWatch"

  #-------------------------------------------------------------
  # Evidently送信先設定
  #-------------------------------------------------------------

  # destination_arn (Optional)
  # 設定内容: 送信先がEvidentlyの場合に、メトリクスを受信するEvidentlyの実験ARNを指定します。
  # 設定可能な値: 有効なCloudWatch Evidentlyの実験ARN
  # 省略時: destination が "CloudWatch" の場合は不要
  # 注意: destination が "Evidently" の場合のみ使用します。
  #       "CloudWatch" の場合はこのパラメータを指定しないでください。
  destination_arn = null

  # iam_role_arn (Optional)
  # 設定内容: 送信先がEvidentlyの場合に、実験への書き込み権限を持つIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 省略時: destination が "CloudWatch" の場合は不要
  # 注意: destination が "Evidently" の場合は必須です。
  #       "CloudWatch" の場合はこのパラメータを指定しないでください。
  iam_role_arn = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: メトリクスを送信するCloudWatch RUMアプリモニターの名前
#---------------------------------------------------------------
