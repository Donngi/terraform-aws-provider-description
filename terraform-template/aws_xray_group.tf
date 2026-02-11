#---------------------------------------------------------------
# AWS X-Ray Group
#---------------------------------------------------------------
#
# AWS X-Rayのグループをプロビジョニングするリソースです。
# グループはフィルター式で定義されたトレースのコレクションで、
# 追加のサービスグラフの生成やAmazon CloudWatchメトリクスの供給に使用できます。
# 受信トレースをフィルター式と比較し、条件に一致するトレースを収集・分類します。
#
# AWS公式ドキュメント:
#   - X-Rayグループの設定: https://docs.aws.amazon.com/xray/latest/devguide/xray-console-groups.html
#   - フィルター式の使用: https://docs.aws.amazon.com/xray/latest/devguide/xray-console-filters.html
#   - X-Ray Insightsの使用: https://docs.aws.amazon.com/xray/latest/devguide/xray-console-insights.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/xray_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-06
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_xray_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # group_name (Required)
  # 設定内容: グループの名前を指定します。
  # 設定可能な値: 最大32文字の文字列。英数字およびダッシュが使用可能（大文字小文字区別あり）
  # 注意: グループ名は一意である必要があります。作成後に名前を変更することはできません。
  #       変更する場合は削除して再作成が必要です。
  group_name = "example-group"

  # filter_expression (Required)
  # 設定内容: トレースをグループ化するための条件を定義するフィルター式を指定します。
  # 設定可能な値: X-Rayフィルター式構文に従った文字列
  #   - ブール値キーワード: ok, error, throttle, fault, partial, inferred 等
  #   - 数値キーワード: responsetime, duration, http.status 等
  #   - 文字列キーワード: http.url, http.method, http.useragent, user 等
  #   - 複合キーワード: service(), edge(), annotation.*, rootcause.* 等
  #   - 演算子: AND, OR, !, =, !=, <, >, <=, >=, CONTAINS, BEGINSWITH, ENDSWITH
  # フィルター式の例:
  #   - "responsetime > 5" - レスポンス時間が5秒を超えるトレース
  #   - "fault = true AND http.url CONTAINS \"example/game\" AND responsetime >= 5"
  #   - "service(\"my-service\") { fault = true }" - 特定サービスでフォルトが発生したトレース
  # 関連機能: X-Rayフィルター式
  #   フィルター式を使用して、リクエストヘッダー、レスポンスステータス、
  #   インデックス付きフィールドなどに基づいてトレースを絞り込むことができます。
  #   - https://docs.aws.amazon.com/xray/latest/devguide/xray-console-filters.html
  # 注意: グループのフィルター式を更新しても、既に記録されたデータには影響しません。
  #       更新は後続のトレースにのみ適用されます。これにより新旧の式によるグラフが
  #       マージされる場合があります。回避するには既存グループを削除して新規作成してください。
  #       グループは一致するトレースの取得数に基づいて課金されます。
  filter_expression = "responsetime > 5"

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
  # Insights設定
  #-------------------------------------------------------------

  # insights_configuration (Optional)
  # 設定内容: X-Ray Insightsの有効化オプションを設定するブロックです。
  # 関連機能: X-Ray Insights
  #   Insightsはトレースデータを継続的に分析し、障害率が統計モデルの予想範囲を
  #   超えた場合にインサイトを作成して問題の影響を追跡します。
  #   障害の発生箇所、根本原因、関連する影響を特定できます。
  #   - https://docs.aws.amazon.com/xray/latest/devguide/xray-console-insights.html
  insights_configuration {

    # insights_enabled (Required)
    # 設定内容: このグループでInsightsを有効にするかを指定します。
    # 設定可能な値:
    #   - true: Insightsを有効化。統計モデリングによりトレースデータの異常を自動検出
    #   - false: Insightsを無効化
    # 注意: Insightsはグループごとに個別に有効化する必要があります。
    #       notifications_enabledを使用するにはこの値がtrueである必要があります。
    insights_enabled = true

    # notifications_enabled (Optional)
    # 設定内容: Insightsの通知を有効にするかを指定します。
    # 設定可能な値:
    #   - true: インサイトの作成・変更・クローズ時にAmazon EventBridgeへ通知を送信
    #   - false: 通知を無効化
    # 省略時: false
    # 関連機能: X-Ray Insights通知
    #   インサイトイベント（作成、重大な変更、クローズ）ごとに通知が生成されます。
    #   EventBridgeの条件付きルールでSNS通知、Lambda呼び出し、SQSキューへの投稿等が可能です。
    #   - https://docs.aws.amazon.com/xray/latest/devguide/xray-console-insights.html
    # 注意: insights_enabledがtrueの場合にのみ有効です。
    #       通知はベストエフォートで配信され、保証されません。
    notifications_enabled = true
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/xray/latest/devguide/xray-tagging.html
  tags = {
    Name        = "example-xray-group"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: グループのAmazon Resource Name (ARN)
#
# - id: グループのARN（arnと同じ値）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
