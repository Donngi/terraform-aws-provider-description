#---------------------------------------------------------------
# AWS Service Catalog Budget Resource Association
#---------------------------------------------------------------
#
# AWS Service Catalogのポートフォリオまたは製品にAWS Budgetsの予算を
# 関連付けるリソースです。予算をService Catalogリソースに紐付けることで、
# コストの可視化と管理が可能になります。
# 各ポートフォリオまたは製品に関連付けられる予算は1つです。
#
# AWS公式ドキュメント:
#   - Service Catalog 予算管理: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/catalogs_budgets.html
#   - AssociateBudgetWithResource API: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_AssociateBudgetWithResource.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_budget_resource_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_servicecatalog_budget_resource_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # budget_name (Required)
  # 設定内容: 関連付けるAWS Budgetsの予算名を指定します。
  # 設定可能な値: 1〜100文字の文字列
  # 参考: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_AssociateBudgetWithResource.html
  budget_name = "my-service-catalog-budget"

  # resource_id (Required)
  # 設定内容: 予算を関連付けるService Catalogリソースの識別子を指定します。
  # 設定可能な値: ポートフォリオID（例: port-xxxxxxxxxx）またはプロダクトID（例: prod-xxxxxxxxxx）
  #   1〜100文字の文字列。パターン: ^[a-zA-Z0-9_-]*
  # 参考: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_AssociateBudgetWithResource.html
  resource_id = "prod-dnigbtea24ste"

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
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・読み取り・削除操作のタイムアウト時間を指定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "30m"

    # read (Optional)
    # 設定内容: リソース読み取り操作のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "10m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    read = "10m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 関連付けの識別子
#---------------------------------------------------------------
