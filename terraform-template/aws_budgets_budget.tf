#---------------------------------------------------------------
# AWS Budgets Budget
#---------------------------------------------------------------
#
# AWS Budgetsの予算をプロビジョニングするリソースです。
# Cost Explorerが提供するコスト可視化を使用して、予算のステータス、
# 推定コストの予測、AWSの使用状況（無料利用枠を含む）を追跡できます。
#
# AWS公式ドキュメント:
#   - AWS Budgets概要: https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-managing-costs.html
#   - コスト予算の作成: https://docs.aws.amazon.com/cost-management/latest/userguide/create-cost-budget.html
#   - Budget API リファレンス: https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_budgets_Budget.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_budgets_budget" "example" {
  #-------------------------------------------------------------
  # 基本設定 (必須)
  #-------------------------------------------------------------

  # budget_type (Required)
  # 設定内容: この予算が追跡する対象の種類を指定します。
  # 設定可能な値:
  #   - "COST": コスト（金額）を追跡
  #   - "USAGE": 使用量を追跡
  #   - "SAVINGS_PLANS_UTILIZATION": Savings Plans の利用率を追跡
  #   - "SAVINGS_PLANS_COVERAGE": Savings Plans のカバレッジを追跡
  #   - "RI_UTILIZATION": リザーブドインスタンスの利用率を追跡
  #   - "RI_COVERAGE": リザーブドインスタンスのカバレッジを追跡
  budget_type = "COST"

  # time_unit (Required)
  # 設定内容: 予算がリセットされる時間の長さを指定します。
  # 設定可能な値:
  #   - "DAILY": 日次
  #   - "MONTHLY": 月次
  #   - "QUARTERLY": 四半期
  #   - "ANNUALLY": 年次
  time_unit = "MONTHLY"

  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Optional)
  # 設定内容: 予算の名前を指定します。
  # 設定可能な値: アカウント内で一意の文字列
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）
  name = "my-monthly-cost-budget"

  # name_prefix (Optional)
  # 設定内容: 予算名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraformが後ろにランダムなサフィックスを追加します。
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  # name_prefix = "my-budget-"

  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # account_id (Optional)
  # 設定内容: 予算の対象となるアカウントIDを指定します。
  # 設定可能な値: 有効なAWSアカウントID
  # 省略時: 現在のユーザーのアカウントIDが使用されます。
  # account_id = "123456789012"

  # billing_view_arn (Optional)
  # 設定内容: 請求ビューのARNを指定します。
  # 設定可能な値: 有効な請求ビューのARN
  # billing_view_arn = "arn:aws:billing:us-east-1:123456789012:billingview/example"

  #-------------------------------------------------------------
  # 予算額設定
  #-------------------------------------------------------------

  # limit_amount (Optional)
  # 設定内容: 予算の上限金額または使用量を指定します。
  # 設定可能な値: 数値を文字列として指定
  # 注意: planned_limitブロックと排他的（どちらか一方のみ指定可能）
  # 参考: https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/data-type-spend.html
  limit_amount = "1000"

  # limit_unit (Optional)
  # 設定内容: 予算の単位を指定します。
  # 設定可能な値:
  #   - "USD": 米ドル（コスト予算の場合）
  #   - "GB": ギガバイト（使用量予算の場合）
  #   - "PERCENTAGE": パーセント（利用率/カバレッジ予算の場合）
  # 参考: https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/data-type-spend.html
  limit_unit = "USD"

  #-------------------------------------------------------------
  # 期間設定
  #-------------------------------------------------------------

  # time_period_start (Optional)
  # 設定内容: 予算がカバーする期間の開始日を指定します。
  # 設定可能な値: "YYYY-MM-DD_HH:MM" 形式の日時文字列
  # 省略時: 選択した時間単位（time_unit）の開始日がデフォルト
  time_period_start = "2024-01-01_00:00"

  # time_period_end (Optional)
  # 設定内容: 予算がカバーする期間の終了日を指定します。
  # 設定可能な値: "YYYY-MM-DD_HH:MM" 形式の日時文字列
  # 省略時: 終了日の制限なし（継続的な予算）
  time_period_end = "2087-06-15_00:00"

  #-------------------------------------------------------------
  # 自動調整設定
  #-------------------------------------------------------------

  # auto_adjust_data (Optional)
  # 設定内容: 自動調整予算のデータを設定します。
  # 関連機能: 自動調整予算
  #   履歴または予測データに基づいて予算額を自動的に調整します。
  #   - https://docs.aws.amazon.com/cost-management/latest/userguide/budget-methods.html
  # auto_adjust_data {
  #   # auto_adjust_type (Required)
  #   # 設定内容: 自動調整の種類を指定します。
  #   # 設定可能な値:
  #   #   - "FORECAST": 予測データに基づいて調整
  #   #   - "HISTORICAL": 履歴データに基づいて調整
  #   auto_adjust_type = "HISTORICAL"
  #
  #   # historical_options (Optional, Required for HISTORICAL)
  #   # 設定内容: 履歴データに基づく自動調整のオプションを設定します。
  #   # 注意: auto_adjust_typeが"HISTORICAL"の場合に必須
  #   historical_options {
  #     # budget_adjustment_period (Required)
  #     # 設定内容: 移動平均計算に含める予算期間の数を指定します。
  #     # 設定可能な値: 1以上の整数
  #     budget_adjustment_period = 3
  #   }
  # }

  #-------------------------------------------------------------
  # コストフィルター設定
  #-------------------------------------------------------------

  # cost_filter (Optional)
  # 設定内容: 予算に適用するコストフィルターを設定します。
  # 関連機能: コストフィルター
  #   特定のサービス、リージョン、タグなどでコストをフィルタリングします。
  #   - https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-create-filters.html
  cost_filter {
    # name (Required)
    # 設定内容: フィルターの名前を指定します。
    # 設定可能な値:
    #   - "AZ": アベイラビリティゾーン
    #   - "BillingEntity": 請求エンティティ
    #   - "CostCategory": コストカテゴリ
    #   - "InstanceType": インスタンスタイプ
    #   - "InvoicingEntity": 請求書発行エンティティ
    #   - "LegalEntityName": 法的エンティティ名
    #   - "LinkedAccount": リンクされたアカウント
    #   - "Operation": 操作
    #   - "PurchaseType": 購入タイプ
    #   - "Region": リージョン
    #   - "Service": サービス
    #   - "TagKeyValue": タグのキーと値（形式: "TagKey$TagValue"）
    #   - "UsageType": 使用タイプ
    #   - "UsageTypeGroup": 使用タイプグループ
    name = "Service"

    # values (Required)
    # 設定内容: フィルタリングに使用する値のリストを指定します。
    # 設定可能な値: フィルター名に対応する有効な値のリスト
    values = [
      "Amazon Elastic Compute Cloud - Compute",
    ]
  }

  #-------------------------------------------------------------
  # コストタイプ設定
  #-------------------------------------------------------------

  # cost_types (Optional)
  # 設定内容: 予算に含めるコストの種類を設定します。
  # 関連機能: コストタイプ
  #   税金、サブスクリプションなど、予算に含めるコストの種類を指定します。
  cost_types {
    # include_credit (Optional)
    # 設定内容: クレジットを予算に含めるかを指定します。
    # 設定可能な値: true / false
    # 省略時: true
    include_credit = true

    # include_discount (Optional)
    # 設定内容: 割引を予算に含めるかを指定します。
    # 設定可能な値: true / false
    # 省略時: true
    include_discount = true

    # include_other_subscription (Optional)
    # 設定内容: その他のサブスクリプションコストを予算に含めるかを指定します。
    # 設定可能な値: true / false
    # 省略時: true
    include_other_subscription = true

    # include_recurring (Optional)
    # 設定内容: 定期的なコストを予算に含めるかを指定します。
    # 設定可能な値: true / false
    # 省略時: true
    include_recurring = true

    # include_refund (Optional)
    # 設定内容: 返金を予算に含めるかを指定します。
    # 設定可能な値: true / false
    # 省略時: true
    include_refund = true

    # include_subscription (Optional)
    # 設定内容: サブスクリプションコストを予算に含めるかを指定します。
    # 設定可能な値: true / false
    # 省略時: true
    include_subscription = true

    # include_support (Optional)
    # 設定内容: サポートコストを予算に含めるかを指定します。
    # 設定可能な値: true / false
    # 省略時: true
    include_support = true

    # include_tax (Optional)
    # 設定内容: 税金を予算に含めるかを指定します。
    # 設定可能な値: true / false
    # 省略時: true
    include_tax = true

    # include_upfront (Optional)
    # 設定内容: 前払いコストを予算に含めるかを指定します。
    # 設定可能な値: true / false
    # 省略時: true
    include_upfront = true

    # use_amortized (Optional)
    # 設定内容: 償却レートを使用するかを指定します。
    # 設定可能な値: true / false
    # 省略時: false
    use_amortized = false

    # use_blended (Optional)
    # 設定内容: 混合コストを使用するかを指定します。
    # 設定可能な値: true / false
    # 省略時: false
    use_blended = false
  }

  #-------------------------------------------------------------
  # 通知設定
  #-------------------------------------------------------------

  # notification (Optional)
  # 設定内容: 予算アラートの通知を設定します。
  # 関連機能: 予算通知
  #   予算の閾値に達した際に通知を送信します。
  #   複数の通知を定義できます。
  notification {
    # comparison_operator (Required)
    # 設定内容: 条件を評価する比較演算子を指定します。
    # 設定可能な値:
    #   - "LESS_THAN": より小さい
    #   - "EQUAL_TO": 等しい
    #   - "GREATER_THAN": より大きい
    comparison_operator = "GREATER_THAN"

    # notification_type (Required)
    # 設定内容: 通知する予算値の種類を指定します。
    # 設定可能な値:
    #   - "ACTUAL": 実際のコスト/使用量
    #   - "FORECASTED": 予測コスト/使用量
    notification_type = "ACTUAL"

    # threshold (Required)
    # 設定内容: 通知を送信する閾値を指定します。
    # 設定可能な値: 数値
    threshold = 80

    # threshold_type (Required)
    # 設定内容: 閾値の種類を指定します。
    # 設定可能な値:
    #   - "PERCENTAGE": パーセンテージ（予算額に対する割合）
    #   - "ABSOLUTE_VALUE": 絶対値
    threshold_type = "PERCENTAGE"

    # subscriber_email_addresses (Optional)
    # 設定内容: 通知を送信するメールアドレスを指定します。
    # 設定可能な値: メールアドレスのセット
    # 注意: subscriber_email_addressesまたはsubscriber_sns_topic_arnsのいずれかが必須
    subscriber_email_addresses = ["budget-alerts@example.com"]

    # subscriber_sns_topic_arns (Optional)
    # 設定内容: 通知を送信するSNSトピックのARNを指定します。
    # 設定可能な値: SNSトピックARNのセット
    # 注意: subscriber_email_addressesまたはsubscriber_sns_topic_arnsのいずれかが必須
    # subscriber_sns_topic_arns = ["arn:aws:sns:ap-northeast-1:123456789012:budget-alerts"]
  }

  # 予測通知の例
  notification {
    comparison_operator        = "GREATER_THAN"
    notification_type          = "FORECASTED"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    subscriber_email_addresses = ["budget-alerts@example.com"]
  }

  #-------------------------------------------------------------
  # 計画された予算制限（オプション）
  #-------------------------------------------------------------

  # planned_limit (Optional)
  # 設定内容: 期間ごとに異なる予算額を設定します。
  # 関連機能: 計画された予算
  #   月次または四半期の予算で、期間ごとに異なる金額を設定できます。
  #   - https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_budgets_Budget.html#awscostmanagement-Type-budgets_Budget-PlannedBudgetLimits
  # 注意: limit_amount/limit_unitと排他的（どちらか一方のみ指定可能）
  # planned_limit {
  #   # start_time (Required)
  #   # 設定内容: この予算制限の開始時刻を指定します。
  #   # 設定可能な値: "YYYY-MM-DD_HH:MM" 形式の日時文字列
  #   start_time = "2024-01-01_00:00"
  #
  #   # amount (Required)
  #   # 設定内容: この期間の予算額を指定します。
  #   # 設定可能な値: 数値を文字列として指定
  #   amount = "1000"
  #
  #   # unit (Required)
  #   # 設定内容: 予算の単位を指定します。
  #   # 設定可能な値: "USD", "GB" など
  #   unit = "USD"
  # }
  #
  # planned_limit {
  #   start_time = "2024-02-01_00:00"
  #   amount     = "1200"
  #   unit       = "USD"
  # }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-monthly-cost-budget"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 予算のAmazon Resource Name (ARN)
#
# - id: リソースのID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#
# auto_adjust_dataブロック内:
# - last_auto_adjust_time: 予算が最後に自動調整された時刻
#
# historical_optionsブロック内:
# - lookback_available_periods: BudgetAdjustmentPeriod内で現在の予算上限の
#                               計算に含まれる予算期間の数
#---------------------------------------------------------------
