#---------------------------------------------------------------
# Amazon Managed Service for Prometheus クエリロギング設定
#---------------------------------------------------------------
#
# Amazon Managed Service for Prometheus (AMP) ワークスペースの
# クエリロギング設定をプロビジョニングするリソースです。
# 指定した QSP（Query Samples Processed）しきい値を超えるクエリを
# Amazon CloudWatch Logs に送信してログに記録し、コスト分析や
# クエリ最適化を支援します。
#
# AWS公式ドキュメント:
#   - クエリコスト管理: https://docs.aws.amazon.com/prometheus/latest/userguide/query-insights-control.html
#   - CreateQueryLoggingConfiguration API: https://docs.aws.amazon.com/prometheus/latest/APIReference/API_CreateQueryLoggingConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/prometheus_query_logging_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_prometheus_query_logging_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # workspace_id (Required)
  # 設定内容: クエリロギングを設定する AMP ワークスペースの ID を指定します。
  # 設定可能な値: 有効な AMP ワークスペース ID 文字列
  workspace_id = "ws-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理する AWS リージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ログ送信先設定
  #-------------------------------------------------------------

  # destination (Required)
  # 設定内容: クエリログの送信先とフィルター条件を定義する設定ブロックです。
  # 注意: 送信先は CloudWatch Logs のみサポートされています。
  # 参考: https://docs.aws.amazon.com/prometheus/latest/APIReference/API_LoggingDestination.html
  destination {

    #-------------------------------------------------------------
    # CloudWatch Logs 送信先設定
    #-------------------------------------------------------------

    # cloudwatch_logs (Required)
    # 設定内容: ログの送信先となる Amazon CloudWatch Logs の設定ブロックです。
    # 注意: ロググループ名を /aws/vendedlogs/ プレフィックスで始めると
    #       CloudWatch Logs リソースポリシーのサイズ制限を回避できます。
    # 参考: https://docs.aws.amazon.com/prometheus/latest/userguide/query-insights-control.html
    cloudwatch_logs {

      # log_group_arn (Required)
      # 設定内容: クエリログを送信する CloudWatch Logs グループの ARN を指定します。
      # 設定可能な値: 有効な CloudWatch Logs グループ ARN（末尾に :* を付与した形式）
      # 注意: ARN は必ず :* で終わる必要があります。
      log_group_arn = "arn:aws:logs:ap-northeast-1:123456789012:log-group:/aws/vendedlogs/prometheus/query-logs:*"
    }

    #-------------------------------------------------------------
    # フィルター設定
    #-------------------------------------------------------------

    # filters (Required)
    # 設定内容: どのクエリをログに記録するかを制御するフィルター設定ブロックです。
    # 注意: QSP しきい値を超えたクエリのみがログに記録されます。
    # 参考: https://docs.aws.amazon.com/prometheus/latest/APIReference/API_LoggingDestination.html
    filters {

      # qsp_threshold (Required)
      # 設定内容: ログ記録対象とするクエリの QSP（Query Samples Processed）しきい値を指定します。
      # 設定可能な値: 正の数値。この値を超えるサンプル数を処理したクエリがログに記録されます。
      # 注意: しきい値を低く設定するほど多くのクエリがログに記録され、
      #       CloudWatch Logs のコストが増加する可能性があります。
      qsp_threshold = 1000
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h45m" などの時間文字列（s: 秒, m: 分, h: 時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h45m" などの時間文字列（s: 秒, m: 分, h: 時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h45m" などの時間文字列（s: 秒, m: 分, h: 時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: クエリロギング設定が関連付けられた AMP ワークスペース ID
#---------------------------------------------------------------
