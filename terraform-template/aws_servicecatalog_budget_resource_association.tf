################################################################################
# AWS Service Catalog Budget Resource Association
################################################################################
# リソース概要:
#   Service Catalog の予算とリソース(ポートフォリオまたは製品)の関連付けを管理します。
#   これにより、Service Catalog リソースに予算制約を適用できます。
#
# ユースケース:
#   - Service Catalog ポートフォリオに予算制限を設定
#   - Service Catalog 製品に予算制約を適用
#   - コスト管理とガバナンスの強化
#
# 公式ドキュメント:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_budget_resource_association
#
# Provider Version: 6.28.0
################################################################################

resource "aws_servicecatalog_budget_resource_association" "example" {
  ################################################################################
  # 必須パラメータ (Required Parameters)
  ################################################################################

  # budget_name - 予算名
  # Type: string (required)
  # 説明: AWS Budgets で作成された予算の名前を指定します
  # 注意事項:
  #   - 既存の AWS Budget の名前を正確に指定する必要があります
  #   - 予算は事前に AWS Budgets サービスで作成されている必要があります
  # 例: "budget-pjtvyakdlyo3m", "monthly-service-catalog-budget"
  budget_name = "budget-pjtvyakdlyo3m"

  # resource_id - リソース識別子
  # Type: string (required)
  # 説明: Service Catalog のリソース ID を指定します
  # 対象リソース:
  #   - Service Catalog ポートフォリオ ID (例: port-xxxxxxxxxxxxx)
  #   - Service Catalog 製品 ID (例: prod-xxxxxxxxxxxxx)
  # 注意事項:
  #   - リソース ID は Service Catalog コンソールまたは API から取得できます
  #   - 関連付けるリソースは事前に作成されている必要があります
  # 例: "prod-dnigbtea24ste", "port-abcd1234efgh"
  resource_id = "prod-dnigbtea24ste"

  ################################################################################
  # オプションパラメータ (Optional Parameters)
  ################################################################################

  # region - リージョン
  # Type: string (optional, computed)
  # 説明: このリソースが管理されるリージョンを指定します
  # デフォルト: プロバイダー設定で指定されたリージョン
  # 注意事項:
  #   - 通常は省略してプロバイダーのデフォルトリージョンを使用します
  #   - マルチリージョン展開の場合に明示的に指定します
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  ################################################################################
  # タイムアウト設定 (Timeouts)
  ################################################################################
  # 説明: リソースの作成、読み取り、削除操作のタイムアウトを設定します
  # 推奨値: デフォルト値で十分な場合が多いですが、大規模環境では調整が必要な場合があります

  # timeouts {
  #   # create - 作成タイムアウト
  #   # Type: string (optional)
  #   # 説明: リソース作成時の最大待機時間
  #   # 形式: "3m" (分), "30s" (秒), "1h" (時間)
  #   # デフォルト: 3分
  #   create = "3m"
  #
  #   # read - 読み取りタイムアウト
  #   # Type: string (optional)
  #   # 説明: リソース読み取り時の最大待機時間
  #   # 形式: "3m" (分), "30s" (秒), "1h" (時間)
  #   # デフォルト: 10分
  #   read = "10m"
  #
  #   # delete - 削除タイムアウト
  #   # Type: string (optional)
  #   # 説明: リソース削除時の最大待機時間
  #   # 形式: "3m" (分), "30s" (秒), "1h" (時間)
  #   # デフォルト: 3分
  #   delete = "3m"
  # }
}

################################################################################
# 出力値 (Outputs)
################################################################################
# 説明: 他のリソースやモジュールで参照可能な出力値

# output "association_id" {
#   description = "Service Catalog 予算リソース関連付けの識別子"
#   value       = aws_servicecatalog_budget_resource_association.example.id
# }

################################################################################
# 使用例: ポートフォリオとの関連付け
################################################################################
# resource "aws_budgets_budget" "service_catalog" {
#   name              = "service-catalog-monthly-budget"
#   budget_type       = "COST"
#   limit_amount      = "1000"
#   limit_unit        = "USD"
#   time_period_start = "2024-01-01_00:00"
#   time_unit         = "MONTHLY"
# }
#
# resource "aws_servicecatalog_portfolio" "example" {
#   name          = "Example Portfolio"
#   description   = "Portfolio with budget constraints"
#   provider_name = "IT Department"
# }
#
# resource "aws_servicecatalog_budget_resource_association" "portfolio_budget" {
#   budget_name = aws_budgets_budget.service_catalog.name
#   resource_id = aws_servicecatalog_portfolio.example.id
# }

################################################################################
# 使用例: 製品との関連付け
################################################################################
# resource "aws_servicecatalog_product" "example" {
#   name  = "Example Product"
#   owner = "IT Department"
#   type  = "CLOUD_FORMATION_TEMPLATE"
#
#   provisioning_artifact_parameters {
#     name        = "v1.0"
#     type        = "CLOUD_FORMATION_TEMPLATE"
#     template_url = "https://s3.amazonaws.com/cf-templates/template.json"
#   }
# }
#
# resource "aws_servicecatalog_budget_resource_association" "product_budget" {
#   budget_name = aws_budgets_budget.service_catalog.name
#   resource_id = aws_servicecatalog_product.example.id
# }

################################################################################
# 補足情報
################################################################################
# 1. 前提条件:
#    - AWS Budgets で予算が作成されていること
#    - Service Catalog のポートフォリオまたは製品が作成されていること
#    - 適切な IAM 権限が設定されていること
#
# 2. IAM 権限:
#    必要な権限:
#    - servicecatalog:AssociateBudgetWithResource
#    - servicecatalog:DisassociateBudgetFromResource
#    - servicecatalog:ListBudgetsForResource
#    - budgets:ViewBudget
#
# 3. 制限事項:
#    - 1つのリソースに複数の予算を関連付けることができます
#    - 関連付けを削除しても、予算自体は削除されません
#    - リージョンごとに関連付けを管理する必要があります
#
# 4. ベストプラクティス:
#    - 予算名には識別しやすい命名規則を使用する
#    - タグを使用して関連リソースを追跡する
#    - アラートと組み合わせて予算超過を監視する
#    - 定期的に予算と実際のコストを確認する
#
# 5. トラブルシューティング:
#    - 予算が見つからない場合: budget_name が正確か確認
#    - リソースが見つからない場合: resource_id が正しいか確認
#    - 権限エラー: IAM ポリシーに必要な権限があるか確認
#
# 6. 関連リソース:
#    - aws_budgets_budget: 予算の作成
#    - aws_servicecatalog_portfolio: ポートフォリオの管理
#    - aws_servicecatalog_product: 製品の管理
#    - aws_servicecatalog_constraint: 制約の設定
################################################################################
