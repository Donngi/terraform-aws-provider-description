#---------------------------------------------------------------
# AWS Budgets Budget
#---------------------------------------------------------------
#
# AWS Budgetsの予算リソースをプロビジョニングします。
# AWSアカウントのコストや使用量を追跡し、設定した閾値を超過した（または
# 超過しそうな）場合に通知を発行する仕組みを提供します。
# コスト予算、使用量予算、リザーブドインスタンス・Savings Plansの
# 利用率/カバレッジ予算、固定予算/計画予算/自動調整予算など、
# 多様な予算タイプを構成可能です。
#
# AWS公式ドキュメント:
#   - AWS Budgetsの概要: https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-managing-costs.html
#   - 予算の作成: https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-create.html
#   - 予算のベストプラクティス: https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-best-practices.html
#   - 予算アクション: https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-controls.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.43.0/docs/resources/budgets_budget
#
# Provider Version: 6.43.0
# Generated: 2026-04-30
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_budgets_budget" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: 予算の一意な名前を指定します。同一アカウント内で一意である必要があります。
  # 設定可能な値: 1-100文字の文字列
  # 省略時: name_prefixが指定されている場合はそれを基に自動生成、
  #         どちらも未指定の場合はTerraformがランダムな一意の名前を生成します。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）
  name = "example-monthly-cost-budget"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: 予算名のプレフィックスを指定します。Terraformが後ろにランダムなサフィックスを追加します。
  # 設定可能な値: 文字列
  # 省略時: nameを使用、または完全にランダムな名前が生成されます。
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  name_prefix = null

  #-------------------------------------------------------------
  # 予算タイプ・期間設定
  #-------------------------------------------------------------

  # budget_type (Required, Forces new resource)
  # 設定内容: 予算で追跡する対象（コストまたは使用量、利用率等）を指定します。
  # 設定可能な値:
  #   - "COST": コスト予算（金銭的コストを追跡）
  #   - "USAGE": 使用量予算（GB、時間などのリソース使用量を追跡）
  #   - "RI_UTILIZATION": リザーブドインスタンスの利用率予算（PERCENTAGE固定）
  #   - "RI_COVERAGE": リザーブドインスタンスのカバレッジ予算
  #   - "SAVINGS_PLANS_UTILIZATION": Savings Plansの利用率予算（PERCENTAGE固定）
  #   - "SAVINGS_PLANS_COVERAGE": Savings Plansのカバレッジ予算
  # 関連機能: AWS Budgets 予算タイプ
  #   コスト/使用量を直接追跡する予算と、RI/Savings Plansの利用効率を追跡する
  #   予算の2系統が存在します。RI_UTILIZATION/SAVINGS_PLANS_UTILIZATION予算では
  #   cost_typesブロックの明示的な設定が必須となります。
  #   - https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-create.html
  budget_type = "COST"

  # time_unit (Required)
  # 設定内容: 予算がリセットされる期間（集計単位）を指定します。
  # 設定可能な値: "DAILY", "MONTHLY", "QUARTERLY", "ANNUALLY"
  # 関連機能: 予算期間
  #   選択した期間ごとに予算がリセットされ、新しい計測サイクルが開始されます。
  #   - https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-create.html
  time_unit = "MONTHLY"

  # time_period_start (Optional, Forces new resource)
  # 設定内容: 予算がカバーする期間の開始日時を指定します。
  # 設定可能な値: "YYYY-MM-DD_HH:MM"形式の文字列（UTC）
  # 省略時: 選択したtime_unitに基づく現在期間の開始時点が使用されます。
  time_period_start = null

  # time_period_end (Optional)
  # 設定内容: 予算がカバーする期間の終了日時を指定します。
  # 設定可能な値: "YYYY-MM-DD_HH:MM"形式の文字列（UTC）
  # 省略時: "2087-06-15_00:00"（実質的に無期限）が使用されます。
  time_period_end = null

  #-------------------------------------------------------------
  # 予算上限設定（固定予算）
  #-------------------------------------------------------------
  # limit_amount/limit_unitは固定値での予算上限指定です。
  # 動的に変動する予算を設定する場合はplanned_limitまたはauto_adjust_dataブロックを利用します。

  # limit_amount (Optional)
  # 設定内容: 予算の上限金額または使用量を文字列で指定します。
  # 設定可能な値: 数値文字列（例: "100", "1000.50"）
  # 省略時: planned_limitまたはauto_adjust_dataブロックで動的に設定する必要があります。
  # 注意: planned_limitまたはauto_adjust_dataと併用不可。
  limit_amount = "1000"

  # limit_unit (Optional)
  # 設定内容: 予算上限の測定単位を指定します。
  # 設定可能な値:
  #   - COST予算: "USD", "JPY"などの通貨コード
  #   - USAGE予算: "GB", "Hours"などのリソース単位
  #   - RI/SP_UTILIZATION予算: "PERCENTAGE"（100固定）
  # 省略時: planned_limitまたはauto_adjust_dataブロックで動的に設定する必要があります。
  limit_unit = "USD"

  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # account_id (Optional, Forces new resource)
  # 設定内容: 予算を作成する対象のAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: 現在のプロバイダー認証で利用しているアカウントIDが使用されます。
  account_id = null

  #-------------------------------------------------------------
  # Billing View設定
  #-------------------------------------------------------------

  # billing_view_arn (Optional)
  # 設定内容: AWS Billing and Cost ManagementのBilling ViewのARNを指定します。
  # 設定可能な値: Billing ViewのARN（例: "arn:aws:billing::123456789012:billingview/custom-..."）
  # 省略時: 標準（プライマリー）のBilling Viewが使用されます。
  # 関連機能: AWS Billing Views
  #   FOCUS形式のBilling Viewを使用することで、特定の組織単位や請求条件に
  #   絞り込んだコストデータに基づく予算を作成できます。
  #   - https://docs.aws.amazon.com/cur/latest/userguide/billing-view.html
  billing_view_arn = null

  #-------------------------------------------------------------
  # メトリクス設定（Billing Views向け）
  #-------------------------------------------------------------

  # metrics (Optional)
  # 設定内容: 予算で追跡するコスト/使用量のメトリクスを指定します。
  #           主にbilling_view_arnを利用したFOCUS形式予算で使用します。
  # 設定可能な値: 文字列のリスト。例:
  #   - "BLENDED_COST"
  #   - "UNBLENDED_COST"
  #   - "AMORTIZED_COST"
  #   - "NET_UNBLENDED_COST"
  #   - "NET_AMORTIZED_COST"
  #   - "USAGE_QUANTITY"
  #   - "NORMALIZED_USAGE_AMOUNT"
  # 省略時: budget_typeとcost_typesから自動的に決定されます。
  # 注意: cost_typesブロックと併用する際は競合する場合があります。
  metrics = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: 予算リソースに付与するタグのキー/値マップを指定します。
  # 設定可能な値: 文字列キーと文字列値のマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tagsで定義されたタグと同じキーを持つタグは、
  #   ここで定義されたものが優先されます。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Environment = "production"
    Owner       = "finops-team"
  }

  #-------------------------------------------------------------
  # 動的予算調整設定（auto_adjust_data）
  #-------------------------------------------------------------
  # 過去の実績または予測データに基づいて予算上限を自動調整します。
  # limit_amount/limit_unitおよびplanned_limitと排他的です。

  # auto_adjust_data (Optional, max 1)
  # 設定内容: 予算上限の自動調整ロジックを定義します。
  # auto_adjust_data {
  #   # auto_adjust_type (Required)
  #   # 設定内容: 自動調整の方式を指定します。
  #   # 設定可能な値:
  #   #   - "HISTORICAL": 過去の実績コストの移動平均に基づき調整（historical_optionsが必須）
  #   #   - "FORECAST": AWSのコスト予測に基づき調整
  #   auto_adjust_type = "HISTORICAL"
  #
  #   # historical_options (Optional, max 1)
  #   # 設定内容: HISTORICAL調整方式で参照する過去期間の設定。
  #   # 注意: auto_adjust_typeが"HISTORICAL"の場合のみ指定可能。
  #   historical_options {
  #     # budget_adjustment_period (Required)
  #     # 設定内容: 移動平均計算に含める過去の予算期間数を指定します。
  #     # 設定可能な値: 1以上の整数（time_unitに応じて推奨値あり）
  #     budget_adjustment_period = 6
  #   }
  # }

  #-------------------------------------------------------------
  # 計画予算上限設定（planned_limit）
  #-------------------------------------------------------------
  # 期間ごとに変動する予算上限を設定します。
  # limit_amount/limit_unitおよびauto_adjust_dataと排他的です。

  # planned_limit (Optional, set, 複数指定可能)
  # 設定内容: 期間別の予算上限を複数定義します。
  # planned_limit {
  #   # start_time (Required)
  #   # 設定内容: この予算上限が適用される開始日時を指定します。
  #   # 設定可能な値: "YYYY-MM-DD_HH:MM"形式の文字列（UTC）
  #   start_time = "2026-01-01_00:00"
  #
  #   # amount (Required)
  #   # 設定内容: この期間における予算上限額または使用量を指定します。
  #   # 設定可能な値: 数値文字列（例: "1000"）
  #   amount = "1000"
  #
  #   # unit (Required)
  #   # 設定内容: 予算上限の単位を指定します。
  #   # 設定可能な値: "USD", "GB", "PERCENTAGE"等（budget_typeに応じる）
  #   unit = "USD"
  # }

  #-------------------------------------------------------------
  # コストタイプ設定（cost_types）
  #-------------------------------------------------------------
  # 予算に含めるコストの種類を細かく制御します。

  # cost_types (Optional, max 1)
  # 設定内容: 予算計算に含める/除外するコスト種別を細かく指定します。
  # cost_types {
  #   # include_credit (Optional)
  #   # 設定内容: AWSクレジット（プロモーションクレジットなど）を予算に含めるか。
  #   # 省略時: true
  #   include_credit = true
  #
  #   # include_discount (Optional)
  #   # 設定内容: ボリュームディスカウントなどの割引を予算に含めるか。
  #   # 省略時: true
  #   include_discount = true
  #
  #   # include_other_subscription (Optional)
  #   # 設定内容: サポート以外のその他のサブスクリプションを予算に含めるか。
  #   # 省略時: true
  #   include_other_subscription = true
  #
  #   # include_recurring (Optional)
  #   # 設定内容: 月額固定料金などの定期的なコストを予算に含めるか。
  #   # 省略時: true
  #   include_recurring = true
  #
  #   # include_refund (Optional)
  #   # 設定内容: AWSからの返金を予算に含めるか。
  #   # 省略時: true
  #   include_refund = true
  #
  #   # include_subscription (Optional)
  #   # 設定内容: RI/Savings Plansなどのサブスクリプションを予算に含めるか。
  #   # 省略時: true
  #   include_subscription = true
  #
  #   # include_support (Optional)
  #   # 設定内容: AWSサポートプランのコストを予算に含めるか。
  #   # 省略時: true
  #   include_support = true
  #
  #   # include_tax (Optional)
  #   # 設定内容: 税金を予算に含めるか。
  #   # 省略時: true
  #   include_tax = true
  #
  #   # include_upfront (Optional)
  #   # 設定内容: RIなどの前払い料金を予算に含めるか。
  #   # 省略時: true
  #   include_upfront = true
  #
  #   # use_amortized (Optional)
  #   # 設定内容: 前払い料金を期間全体に償却（amortize）して計算するか。
  #   # 省略時: false
  #   use_amortized = false
  #
  #   # use_blended (Optional)
  #   # 設定内容: ブレンドコスト（組織全体の平均レート）で計算するか。
  #   # 省略時: false
  #   use_blended = false
  # }

  #-------------------------------------------------------------
  # コストフィルター設定（cost_filter）
  #-------------------------------------------------------------
  # サービス・リージョン・タグなどで予算対象を絞り込みます。
  # filter_expressionと排他的（同時に指定不可）。

  # cost_filter (Optional, set, 複数指定可能)
  # 設定内容: 単一の次元でコストを絞り込むフィルターを指定します。
  # cost_filter {
  #   # name (Required)
  #   # 設定内容: フィルター対象の次元名を指定します。
  #   # 設定可能な値:
  #   #   "AZ", "BillingEntity", "CostCategory", "InstanceType",
  #   #   "InvoicingEntity", "LegalEntityName", "LinkedAccount",
  #   #   "Operation", "PurchaseType", "Region", "Service",
  #   #   "TagKeyValue", "UsageType", "UsageTypeGroup", "RecordType",
  #   #   "Tenancy", "Platform", "DatabaseEngine" など
  #   name = "Service"
  #
  #   # values (Required)
  #   # 設定内容: マッチ対象の値リストを指定します。
  #   # 設定可能な値: 文字列のリスト
  #   values = [
  #     "Amazon Elastic Compute Cloud - Compute",
  #   ]
  # }

  #-------------------------------------------------------------
  # フィルター式設定（filter_expression）
  #-------------------------------------------------------------
  # 論理演算子（and/or/not）を使った高度なフィルタリング条件を指定します。
  # cost_filterと排他的（同時に指定不可）。
  # ネスト深度はAWS APIの制限により最大2段階まで。

  # filter_expression (Optional, max 1)
  # 設定内容: 論理演算子を組み合わせたフィルター式を定義します。
  # filter_expression {
  #   # dimensions (Optional, max 1)
  #   # 設定内容: ディメンションによる単一フィルター。
  #   # dimensions {
  #   #   # key (Required)
  #   #   # 設定内容: フィルター対象のディメンションを指定します。
  #   #   # 設定可能な値: "AZ", "INSTANCE_TYPE", "LINKED_ACCOUNT", "OPERATION",
  #   #   #   "PURCHASE_TYPE", "REGION", "SERVICE", "USAGE_TYPE",
  #   #   #   "USAGE_TYPE_GROUP", "RECORD_TYPE", "OPERATING_SYSTEM",
  #   #   #   "TENANCY", "SCOPE", "PLATFORM", "SUBSCRIPTION_ID",
  #   #   #   "LEGAL_ENTITY_NAME", "DEPLOYMENT_OPTION", "DATABASE_ENGINE",
  #   #   #   "CACHE_ENGINE", "INSTANCE_TYPE_FAMILY", "BILLING_ENTITY",
  #   #   #   "RESERVATION_ID", "RESOURCE_ID", "RIGHTSIZING_TYPE",
  #   #   #   "SAVINGS_PLANS_TYPE", "SAVINGS_PLAN_ARN", "PAYMENT_OPTION",
  #   #   #   "AGREEMENT_END_DATE_TIME_AFTER", "AGREEMENT_END_DATE_TIME_BEFORE"
  #   #   key = "SERVICE"
  #   #
  #   #   # values (Required)
  #   #   # 設定内容: マッチ対象の値リスト。
  #   #   values = ["Amazon Elastic Compute Cloud - Compute"]
  #   #
  #   #   # match_options (Optional)
  #   #   # 設定内容: 値の比較方法を指定します。
  #   #   # 設定可能な値: "EQUALS", "STARTS_WITH", "ENDS_WITH", "CONTAINS",
  #   #   #   "GREATER_THAN_OR_EQUAL", "CASE_SENSITIVE", "CASE_INSENSITIVE"
  #   #   match_options = ["EQUALS"]
  #   # }
  #
  #   # tags (Optional, max 1)
  #   # 設定内容: タグキーによる単一フィルター。
  #   # tags {
  #   #   # key (Optional)
  #   #   # 設定内容: フィルター対象のタグキーを指定します。
  #   #   key = "Environment"
  #   #
  #   #   # values (Optional)
  #   #   # 設定内容: マッチ対象のタグ値リスト。
  #   #   values = ["Production"]
  #   #
  #   #   # match_options (Optional)
  #   #   # 設定内容: 値の比較方法。
  #   #   match_options = ["EQUALS"]
  #   # }
  #
  #   # cost_categories (Optional, max 1)
  #   # 設定内容: コストカテゴリキーによる単一フィルター。
  #   # cost_categories {
  #   #   # key (Optional)
  #   #   # 設定内容: フィルター対象のコストカテゴリキー。
  #   #   key = "Environment"
  #   #
  #   #   # values (Optional)
  #   #   # 設定内容: マッチ対象のコストカテゴリ値リスト。
  #   #   values = ["production"]
  #   #
  #   #   # match_options (Optional)
  #   #   # 設定内容: 値の比較方法。
  #   #   match_options = ["EQUALS"]
  #   # }
  #
  #   # and (Optional, list, 2つ以上指定)
  #   # 設定内容: 全条件AND結合のオペランドを指定します。
  #   #           各andブロック内には dimensions/tags/cost_categories/not/or のいずれかを指定可能。
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
  #   # or (Optional, list, 2つ以上指定)
  #   # 設定内容: 条件OR結合のオペランドを指定します。
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
  #   # not (Optional, max 1)
  #   # 設定内容: 否定条件を指定します。
  #   # not {
  #   #   dimensions {
  #   #     key    = "REGION"
  #   #     values = ["us-west-2"]
  #   #   }
  #   # }
  # }

  #-------------------------------------------------------------
  # 通知設定（notification）
  #-------------------------------------------------------------
  # 予算の閾値到達/超過時の通知を構成します。

  # notification (Optional, set, 複数指定可能)
  # 設定内容: 予算閾値超過時の通知ルールを定義します。
  # notification {
  #   # comparison_operator (Required)
  #   # 設定内容: 閾値との比較方法を指定します。
  #   # 設定可能な値: "GREATER_THAN", "LESS_THAN", "EQUAL_TO"
  #   comparison_operator = "GREATER_THAN"
  #
  #   # threshold (Required)
  #   # 設定内容: 通知をトリガーする閾値（数値）を指定します。
  #   # 設定可能な値: 0以上の数値（PERCENTAGEの場合は0-100）
  #   threshold = 80
  #
  #   # threshold_type (Required)
  #   # 設定内容: 閾値の解釈方法を指定します。
  #   # 設定可能な値:
  #   #   - "PERCENTAGE": 予算上限に対する割合（例: 80 = 80%）
  #   #   - "ABSOLUTE_VALUE": 絶対値（通貨や使用量の実数）
  #   threshold_type = "PERCENTAGE"
  #
  #   # notification_type (Required)
  #   # 設定内容: 通知トリガーの基準値を指定します。
  #   # 設定可能な値:
  #   #   - "ACTUAL": 実績値が閾値に到達した場合に通知
  #   #   - "FORECASTED": 予測値が閾値に到達する見込みの場合に通知
  #   notification_type = "ACTUAL"
  #
  #   # subscriber_email_addresses (Optional)
  #   # 設定内容: 通知を受信するメールアドレスのリストを指定します。
  #   # 設定可能な値: メールアドレスの文字列セット（最大10件）
  #   # 省略時: subscriber_sns_topic_arnsの指定が必要です。
  #   subscriber_email_addresses = [
  #     "finops@example.com",
  #   ]
  #
  #   # subscriber_sns_topic_arns (Optional)
  #   # 設定内容: 通知を送信するSNSトピックのARNリストを指定します。
  #   # 設定可能な値: SNSトピックARNの文字列セット
  #   # 省略時: subscriber_email_addressesの指定が必要です。
  #   # 注意: SNSトピック側でAWS Budgetsからの発行を許可するアクセスポリシー設定が必要です。
  #   #       https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-sns-policy.html
  #   subscriber_sns_topic_arns = [
  #     "arn:aws:sns:us-east-1:123456789012:budget-alerts",
  #   ]
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 予算リソースのAmazon Resource Name (ARN)
# - id: 予算のリソース識別子（"<account_id>:<budget_name>"形式）
# - tags_all: プロバイダーのdefault_tagsを含むリソース全タグのマップ
# - auto_adjust_data.last_auto_adjust_time: 予算が最後に自動調整された日時
# - auto_adjust_data.historical_options.lookback_available_periods:
#     利用可能な過去予算期間数（実績データのある期間に基づく）
#---------------------------------------------------------------
