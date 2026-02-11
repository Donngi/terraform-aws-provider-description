#---------------------------------------------------------------
# AWS CloudWatch Log Metric Filter
#---------------------------------------------------------------
#
# Amazon CloudWatch Logsのメトリクスフィルターをプロビジョニングするリソースです。
# メトリクスフィルターは、ログデータから特定のパターンを検索・抽出し、
# その結果をCloudWatchメトリクスに変換します。
# これにより、ログイベントに基づいたアラームの設定やダッシュボードでの可視化が可能になります。
#
# AWS公式ドキュメント:
#   - メトリクスフィルターによるログデータからのメトリクス作成: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/MonitoringLogData.html
#   - フィルターパターンの構文: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: メトリクスフィルターの名前を指定します。
  # 設定可能な値: 文字列
  name = "my-metric-filter"

  # log_group_name (Required)
  # 設定内容: メトリクスフィルターを関連付けるロググループの名前を指定します。
  # 設定可能な値: 既存のロググループ名
  log_group_name = aws_cloudwatch_log_group.example.name

  # pattern (Required)
  # 設定内容: ログイベントからメトリクスデータを抽出するためのフィルターパターンを指定します。
  # 設定可能な値: 有効なCloudWatch Logsフィルターパターン
  #   - 空文字列(""): すべてのログイベントにマッチ
  #   - 用語によるマッチ: "ERROR"、"Exception"など
  #   - JSON形式: { $.errorCode = "*" }
  #   - スペース区切り形式: [ip, user, username, timestamp, request, status_code, bytes]
  #   - 正規表現: %regex%パターン（一部対応）
  # 関連機能: CloudWatch Logsフィルターパターン構文
  #   フィルターパターンを使用してログデータを検索・フィルタリングし、
  #   特定の条件に一致するログイベントを抽出できます。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html
  pattern = "[timestamp, request_id, log_level = ERROR, ...]"

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
  # ログ変換設定
  #-------------------------------------------------------------

  # apply_on_transformed_logs (Optional)
  # 設定内容: メトリクスフィルターを変換後のログイベントに適用するかどうかを指定します。
  # 設定可能な値:
  #   - true: 変換後のログイベントに対してフィルターを適用
  #   - false (デフォルト): 元の取り込みログイベントに対してフィルターを適用
  # 注意: アクティブなログトランスフォーマーを持つロググループにのみ有効
  # 関連機能: CloudWatch Logs ログトランスフォーマー
  #   ログイベントを変換・正規化する機能。変換後のログに対してフィルターを適用可能。
  apply_on_transformed_logs = false

  #-------------------------------------------------------------
  # メトリクス変換設定 (Required)
  #-------------------------------------------------------------
  # メトリクスデータの発行方法を定義するブロックです。
  # 1つのメトリクス変換ブロックが必須です。

  metric_transformation {
    # name (Required)
    # 設定内容: 発行先のCloudWatchメトリクス名を指定します。
    # 設定可能な値: 1-255文字の文字列（例: "ErrorCount", "RequestLatency"）
    name = "ErrorCount"

    # namespace (Required)
    # 設定内容: CloudWatchメトリクスの送信先名前空間を指定します。
    # 設定可能な値: 1-255文字の文字列
    # 注意: カスタム名前空間を使用して関連メトリクスをグループ化します。
    #       AWS予約名前空間（AWS/で始まるもの）は使用できません。
    namespace = "MyApplication"

    # value (Required)
    # 設定内容: メトリクスに発行する値を指定します。
    # 設定可能な値:
    #   - 固定値: "1"（イベント発生回数をカウント）
    #   - JSONログからの抽出値: "$.latency"（JSONフィールドの値を使用）
    #   - スペース区切りログからの抽出値: "$bytes"（名前付きフィールドの値を使用）
    # 例: エラー発生回数をカウントする場合は "1"、
    #     転送バイト数を記録する場合はログイベントから抽出した値を使用
    value = "1"

    # default_value (Optional)
    # 設定内容: フィルターパターンがログイベントにマッチしない場合に発行する値を指定します。
    # 設定可能な値: 数値を表す文字列（例: "0"）
    # 注意: dimensionsと排他的（どちらか一方のみ指定可能）
    # 用途: メトリクスに常にデータポイントを持たせたい場合に使用。
    #       マッチしない期間にもゼロ値を記録することで、グラフの連続性を保てます。
    default_value = "0"

    # dimensions (Optional)
    # 設定内容: メトリクスのディメンションとして使用するフィールドのマップを指定します。
    # 設定可能な値: キーと値のマップ（最大3つのディメンション）
    #   - キー: ディメンション名（1-255文字）
    #   - 値: ログイベントから抽出するフィールド（JSONの場合: "$.field"）
    # 注意: default_valueと排他的（どちらか一方のみ指定可能）
    # 警告: IPアドレスやrequestIDなどの高カーディナリティフィールドをディメンションとして
    #       使用すると、予期しない高額な課金が発生する可能性があります。
    # dimensions = {
    #   "ServiceName" = "$.service"
    #   "Environment" = "$.env"
    # }

    # unit (Optional)
    # 設定内容: メトリクスに割り当てる単位を指定します。
    # 設定可能な値:
    #   - 時間単位: "Seconds", "Microseconds", "Milliseconds"
    #   - バイト単位: "Bytes", "Kilobytes", "Megabytes", "Gigabytes", "Terabytes"
    #   - ビット単位: "Bits", "Kilobits", "Megabits", "Gigabits", "Terabits"
    #   - スループット: "Bytes/Second", "Kilobytes/Second", "Megabytes/Second",
    #                   "Gigabytes/Second", "Terabytes/Second"
    #   - ビットレート: "Bits/Second", "Kilobits/Second", "Megabits/Second",
    #                   "Gigabits/Second", "Terabits/Second"
    #   - その他: "Percent", "Count", "Count/Second", "None"
    # 省略時: "None"が設定されます
    unit = "Count"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: メトリクスフィルターの名前
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 関連リソース例
#---------------------------------------------------------------
# メトリクスフィルターを使用するには、対象となるロググループが必要です。

# resource "aws_cloudwatch_log_group" "example" {
#   name = "/aws/my-application/logs"
# }
