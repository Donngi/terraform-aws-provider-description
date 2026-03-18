#-------
# aws_budgets_budget
# AWS Budgetsリソース - コスト・使用量の予算管理と通知設定
#
# Provider Version: 6.36.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget
# Generated: 2026-03-18
#
# このリソースは、AWSのコストや使用量を監視するための予算を作成します。
# 予算の上限設定、コストフィルター、通知アラートなどを構成できます。
#
# NOTE: RI_UTILIZATIONまたはSAVINGS_PLANS_UTILIZATIONタイプの予算では、
# cost_typesブロックの明示的な設定が必須です（デフォルト値と競合するため）。
# RI_UTILIZATION予算では、サービスのcost_filterも必須です。
# cost_filterとfilter_expressionは排他的であり、同時に指定できません。
#-------

resource "aws_budgets_budget" "example" {
  #-------
  # 予算タイプ・期間設定
  #-------

  # 予算のタイプ
  # 設定内容: 予算で追跡する対象（コストまたは使用量）を指定
  # 設定可能な値:
  #   - COST: コスト予算（金銭的コストを追跡）
  #   - USAGE: 使用量予算（リソースの使用量を追跡、GB・時間など）
  #   - SAVINGS_PLANS_UTILIZATION: Savings Plansの利用率予算（100%を上限とする）
  #   - SAVINGS_PLANS_COVERAGE: Savings Plansのカバレッジ予算
  #   - RI_UTILIZATION: リザーブドインスタンスの利用率予算（100%固定）
  #   - RI_COVERAGE: リザーブドインスタンスのカバレッジ予算
  budget_type = "COST"

  # 予算期間の単位
  # 設定内容: 予算がリセットされる期間を指定
  # 設定可能な値: MONTHLY、QUARTERLY、ANNUALLY、DAILY
  time_unit = "MONTHLY"

  #-------
  # 予算名設定（name または name_prefix のいずれかを指定）
  #-------

  # 予算名
  # 設定内容: 予算の一意な名前（アカウント内で一意である必要がある）
  # 省略時: name_prefixが使用される、または自動生成される
  name = "monthly-cost-budget"

  # 予算名のプレフィックス（nameと排他的）
  # 設定内容: 予算名の接頭辞（Terraformが自動的にユニークな名前を生成）
  # 省略時: nameで指定された名前が使用される
  name_prefix = null

  #-------
  # 予算上限設定（固定予算）
  #-------

  # 予算上限額
  # 設定内容: 予算の上限金額または使用量
  # 省略時: planned_limitまたはauto_adjust_dataで動的に設定する必要がある
  limit_amount = "1000"

  # 予算上限の単位
  # 設定内容: 予算の測定単位
  # 設定可能な値:
  #   - COSTタイプ: USD、JPYなどの通貨コード
  #   - USAGEタイプ: GB、TB、時間（Hours）など
  #   - 利用率タイプ: PERCENTAGE（100固定）
  # 省略時: planned_limitまたはauto_adjust_dataで動的に設定する必要がある
  limit_unit = "USD"

  #-------
  # アカウント設定
  #-------

  # 対象アカウントID
  # 設定内容: 予算を作成するAWSアカウントID
  # 省略時: 現在のユーザーのアカウントIDが使用される
  account_id = null

  #-------
  # Billing View設定
  #-------

  # Billing ViewのARN
  # 設定内容: AWS Billing and Cost Managementのビリングビュー（FOCUS形式）のARN
  # 省略時: 標準のコストデータを使用
  billing_view_arn = null

  #-------
  # 期間設定
  #-------

  # 予算期間の開始日時
  # 設定内容: 予算がカバーする期間の開始日時
  # 省略時: 選択した期間単位の開始時点がデフォルトとして使用される
  # フォーマット: YYYY-MM-DD_HH:MM（例: 2024-01-01_00:00）
  time_period_start = null

  # 予算期間の終了日時
  # 設定内容: 予算がカバーする期間の終了日時
  # 省略時: 制限なし（無期限）
  # フォーマット: YYYY-MM-DD_HH:MM（例: 2025-12-31_23:59）
  time_period_end = null

  #-------
  # タグ設定
  #-------

  # リソースタグ
  # 設定内容: 予算リソースに付与するタグのマップ
  # 省略時: タグなし
  tags = null

  #-------
  # 動的予算調整設定（auto_adjust_data）
  #-------
  # 過去の実績データまたは予測データに基づいて予算を自動調整する設定
  # limit_amount/limit_unitと排他的な設定

  # auto_adjust_data {
  #   # 自動調整タイプ
  #   # 設定内容: 予算の自動調整の基準となるデータタイプ
  #   # 設定可能な値:
  #   #   - HISTORICAL: 過去の実績データに基づいて調整
  #   #   - FORECAST: 予測データに基づいて調整
  #   auto_adjust_type = "HISTORICAL"
  #
  #   # 過去データオプション（auto_adjust_typeがHISTORICALの場合に必須）
  #   historical_options {
  #     # 予算調整期間
  #     # 設定内容: 移動平均の計算に含める予算期間の数
  #     # 設定可能な値: 1以上の整数
  #     budget_adjustment_period = 6
  #
  #     # 利用可能な参照期間数（読み取り専用）
  #     # 設定内容: 予算上限計算に実際に使用される期間数（コストデータがない期間は除外される）
  #     # 省略時: budget_adjustment_periodと過去データから自動計算される
  #   }
  #
  #   # 最終自動調整時刻（読み取り専用）
  #   # 設定内容: 予算が最後に自動調整された日時
  # }

  #-------
  # 計画予算上限設定（planned_limit）
  #-------
  # 時期によって変動する予算上限を複数設定
  # limit_amount/limit_unitおよびauto_adjust_dataと排他的な設定

  # planned_limit {
  #   # 開始日時
  #   # 設定内容: この予算上限が適用される開始日時
  #   # フォーマット: YYYY-MM-DD_HH:MM（例: 2024-01-01_00:00）
  #   start_time = "2024-01-01_00:00"
  #
  #   # 予算上限額
  #   # 設定内容: この期間の予算上限金額または使用量
  #   amount = "1000"
  #
  #   # 予算上限の単位
  #   # 設定内容: 予算の測定単位（USD、GBなど）
  #   unit = "USD"
  # }
  #
  # # 複数の期間別予算を設定可能
  # planned_limit {
  #   start_time = "2024-07-01_00:00"
  #   amount     = "1500"
  #   unit       = "USD"
  # }

  #-------
  # コストタイプ設定（cost_types）
  #-------
  # 予算に含めるコストの種類を詳細に設定

  # cost_types {
  #   # クレジットを含める
  #   # 設定内容: AWSクレジット（プロモーションクレジットなど）を予算に含めるか
  #   # 省略時: true
  #   include_credit = true
  #
  #   # ディスカウントを含める
  #   # 設定内容: ボリュームディスカウントやその他の割引を予算に含めるか
  #   # 省略時: true
  #   include_discount = true
  #
  #   # その他のサブスクリプションを含める
  #   # 設定内容: サポートプラン以外のサブスクリプションコストを予算に含めるか
  #   # 省略時: true
  #   include_other_subscription = true
  #
  #   # 定期的なコストを含める
  #   # 設定内容: 定期的な料金（月額料金など）を予算に含めるか
  #   # 省略時: true
  #   include_recurring = true
  #
  #   # 返金を含める
  #   # 設定内容: AWSからの返金を予算に含めるか
  #   # 省略時: true
  #   include_refund = true
  #
  #   # サブスクリプションを含める
  #   # 設定内容: リザーブドインスタンスやSavings Plansなどのサブスクリプション料金を含めるか
  #   # 省略時: true
  #   include_subscription = true
  #
  #   # サポートコストを含める
  #   # 設定内容: AWSサポートプランのコストを予算に含めるか
  #   # 省略時: true
  #   include_support = true
  #
  #   # 税金を含める
  #   # 設定内容: 税金を予算に含めるか
  #   # 省略時: true
  #   include_tax = true
  #
  #   # 前払い料金を含める
  #   # 設定内容: リザーブドインスタンスなどの前払い料金を予算に含めるか
  #   # 省略時: true
  #   include_upfront = true
  #
  #   # 償却コストを使用
  #   # 設定内容: 前払い料金を期間全体に分散して計算するか
  #   # 省略時: false
  #   use_amortized = false
  #
  #   # ブレンドコストを使用
  #   # 設定内容: 組織全体の平均レートを使用して計算するか
  #   # 省略時: false
  #   use_blended = false
  # }

  #-------
  # コストフィルター設定（cost_filter）
  #-------
  # 特定のサービス、リージョン、タグなどで予算の対象を絞り込む
  # filter_expressionと排他的（同時に使用不可）

  # cost_filter {
  #   # フィルター名
  #   # 設定内容: コストフィルターの種類を指定
  #   # 設定可能な値:
  #   #   - AZ: アベイラビリティーゾーン
  #   #   - BillingEntity: 課金エンティティ（AWS、AWS Marketplaceなど）
  #   #   - CostCategory: コストカテゴリ
  #   #   - InstanceType: EC2インスタンスタイプ
  #   #   - InvoicingEntity: 請求エンティティ
  #   #   - LegalEntityName: 法的エンティティ名
  #   #   - LinkedAccount: リンクされたアカウントID
  #   #   - Operation: AWSオペレーション（例: RunInstances）
  #   #   - PurchaseType: 購入タイプ（On-Demand、Reserved、Spot）
  #   #   - Region: AWSリージョン
  #   #   - Service: AWSサービス名
  #   #   - TagKeyValue: タグのキーと値のペア
  #   #   - UsageType: 使用タイプ
  #   #   - UsageTypeGroup: 使用タイプグループ
  #   name = "Service"
  #
  #   # フィルター値
  #   # 設定内容: フィルター条件に一致する値のリスト
  #   values = [
  #     "Amazon Elastic Compute Cloud - Compute",
  #   ]
  # }

  #-------
  # フィルター式設定（filter_expression）
  #-------
  # 高度なフィルタリング条件を論理演算子（AND/OR/NOT）で組み合わせて指定
  # cost_filterと排他的（同時に使用不可）
  # ネストの最大深度はAWS APIの制限により2段階まで

  # filter_expression {
  #   # ディメンションフィルター（単一条件の場合）
  #   # 設定内容: ディメンションによるフィルタリング
  #   # 備考: and/or/not/dimensions/tags/cost_categoriesのうち1つのみ指定可能
  #   # dimensions {
  #   #   # フィルターキー
  #   #   # 設定内容: フィルタリングするディメンションの種類
  #   #   # 設定可能な値: AZ、INSTANCE_TYPE、LINKED_ACCOUNT、OPERATION、PURCHASE_TYPE、
  #   #   #   REGION、SERVICE、USAGE_TYPE、USAGE_TYPE_GROUP、RECORD_TYPE、
  #   #   #   OPERATING_SYSTEM、TENANCY、SCOPE、PLATFORM、SUBSCRIPTION_ID、
  #   #   #   LEGAL_ENTITY_NAME、DEPLOYMENT_OPTION、DATABASE_ENGINE、CACHE_ENGINE、
  #   #   #   INSTANCE_TYPE_FAMILY、BILLING_ENTITY、RESERVATION_ID、RESOURCE_ID、
  #   #   #   RIGHTSIZING_TYPE、SAVINGS_PLANS_TYPE、SAVINGS_PLAN_ARN、PAYMENT_OPTION、
  #   #   #   AGREEMENT_END_DATE_TIME_AFTER、AGREEMENT_END_DATE_TIME_BEFORE
  #   #   key = "SERVICE"
  #   #
  #   #   # フィルター値
  #   #   # 設定内容: マッチさせる値のリスト（1つ以上必須）
  #   #   values = ["Amazon Elastic Compute Cloud - Compute"]
  #   #
  #   #   # マッチオプション
  #   #   # 設定内容: 値の比較方法を指定
  #   #   # 設定可能な値: EQUALS、STARTS_WITH、ENDS_WITH、CONTAINS、
  #   #   #   GREATER_THAN_OR_EQUAL、CASE_SENSITIVE、CASE_INSENSITIVE
  #   #   # 省略時: デフォルトの比較方法が使用される
  #   #   match_options = null
  #   # }
  #
  #   # タグフィルター
  #   # tags {
  #   #   # タグキー
  #   #   # 設定内容: フィルタリングするタグのキー名
  #   #   key = "Environment"
  #   #
  #   #   # タグ値
  #   #   # 設定内容: マッチさせるタグ値のリスト
  #   #   values = ["Production"]
  #   #
  #   #   # マッチオプション
  #   #   # 設定内容: 値の比較方法を指定
  #   #   # 設定可能な値: EQUALS、STARTS_WITH、ENDS_WITH、CONTAINS、
  #   #   #   GREATER_THAN_OR_EQUAL、CASE_SENSITIVE、CASE_INSENSITIVE
  #   #   # 省略時: デフォルトの比較方法が使用される
  #   #   match_options = null
  #   # }
  #
  #   # コストカテゴリフィルター
  #   # cost_categories {
  #   #   # コストカテゴリキー
  #   #   # 設定内容: フィルタリングするコストカテゴリのキー名
  #   #   key = "Environment"
  #   #
  #   #   # コストカテゴリ値
  #   #   # 設定内容: マッチさせるコストカテゴリ値のリスト
  #   #   values = ["production"]
  #   #
  #   #   # マッチオプション
  #   #   # 設定内容: 値の比較方法を指定
  #   #   # 設定可能な値: EQUALS、STARTS_WITH、ENDS_WITH、CONTAINS、
  #   #   #   GREATER_THAN_OR_EQUAL、CASE_SENSITIVE、CASE_INSENSITIVE
  #   #   # 省略時: デフォルトの比較方法が使用される
  #   #   match_options = null
  #   # }
  #
  #   # AND条件（2つ以上のオペランドが必要）
  #   # 各andブロックに1つのリーフフィルターを指定
  #   # and {
  #   #   dimensions {
  #   #     key    = "SERVICE"
  #   #     values = ["Amazon Elastic Compute Cloud - Compute"]
  #   #   }
  #   # }
  #   # and {
  #   #   tags {
  #   #     key    = "Environment"
  #   #     values = ["Production"]
  #   #   }
  #   # }
  #
  #   # OR条件（2つ以上のオペランドが必要）
  #   # 各orブロックに1つのリーフフィルターを指定
  #   # or {
  #   #   dimensions {
  #   #     key    = "SERVICE"
  #   #     values = ["Amazon Elastic Compute Cloud - Compute"]
  #   #   }
  #   # }
  #   # or {
  #   #   dimensions {
  #   #     key    = "SERVICE"
  #   #     values = ["Amazon Relational Database Service"]
  #   #   }
  #   # }
  #
  #   # NOT条件（1つのフィルターを否定）
  #   # not {
  #   #   dimensions {
  #   #     key    = "REGION"
  #   #     values = ["us-west-2"]
  #   #   }
  #   # }
  # }

  #-------
  # 通知設定（notification）
  #-------
  # 予算の閾値を超えた場合の通知設定

  # notification {
  #   # 比較演算子
  #   # 設定内容: 閾値との比較方法
  #   # 設定可能な値:
  #   #   - GREATER_THAN: 閾値を超えた場合
  #   #   - EQUAL_TO: 閾値と等しい場合
  #   #   - LESS_THAN: 閾値未満の場合
  #   comparison_operator = "GREATER_THAN"
  #
  #   # 閾値
  #   # 設定内容: 通知をトリガーする閾値（数値）
  #   threshold = 80
  #
  #   # 閾値のタイプ
  #   # 設定内容: 閾値の測定方法
  #   # 設定可能な値:
  #   #   - PERCENTAGE: パーセンテージ（予算上限の80%など）
  #   #   - ABSOLUTE_VALUE: 絶対値（800ドルなど）
  #   threshold_type = "PERCENTAGE"
  #
  #   # 通知タイプ
  #   # 設定内容: 実績値または予測値のどちらで通知するか
  #   # 設定可能な値:
  #   #   - ACTUAL: 実際のコスト/使用量が閾値を超えた場合
  #   #   - FORECASTED: 予測されるコスト/使用量が閾値を超える見込みの場合
  #   notification_type = "ACTUAL"
  #
  #   # 通知先メールアドレス
  #   # 設定内容: 通知を受信するメールアドレスのリスト
  #   # 省略時: subscriber_sns_topic_arnsを指定する必要がある
  #   subscriber_email_addresses = [
  #     "finance@example.com",
  #   ]
  #
  #   # 通知先SNSトピックARN
  #   # 設定内容: 通知を送信するSNSトピックのARNリスト
  #   # 省略時: subscriber_email_addressesを指定する必要がある
  #   # subscriber_sns_topic_arns = [
  #   #   "arn:aws:sns:us-east-1:123456789012:budget-alerts",
  #   # ]
  # }
}

#-------
# Attributes Reference（参照可能な属性）
#-------
# arn: 予算のARN
# id: 予算のID（リソース識別子）
# tags_all: プロバイダーのdefault_tagsを含む全てのタグのマップ
#
# auto_adjust_data使用時の参照可能な属性:
#   - last_auto_adjust_time: 最後に自動調整された日時
#   - historical_options.lookback_available_periods: 実際に使用される参照期間数
#-------
