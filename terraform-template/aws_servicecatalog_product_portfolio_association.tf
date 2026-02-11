#---------------------------------------------------------------
# AWS Service Catalog Product Portfolio Association
#---------------------------------------------------------------
#
# AWS Service Catalogの製品とポートフォリオの関連付けを管理します。
# 製品をポートフォリオに関連付けることで、エンドユーザーがポートフォリオ経由で
# 製品をプロビジョニングできるようになります。
#
# AWS公式ドキュメント:
#   - AssociateProductWithPortfolio API: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_AssociateProductWithPortfolio.html
#   - ポートフォリオへの製品追加: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/catalogs_portfolios_adding-products.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_product_portfolio_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_servicecatalog_product_portfolio_association" "example" {
  # ------------------------------
  # 必須パラメータ
  # ------------------------------

  # ポートフォリオID
  # AWS Service Catalogのポートフォリオ識別子を指定します。
  # 形式: port-xxxxxxxxxx
  # 長さ制約: 1〜100文字
  # パターン: ^[a-zA-Z0-9_\-]*
  portfolio_id = "port-68656c6c6f"

  # 製品ID
  # AWS Service Catalogの製品識別子を指定します。
  # この製品が指定されたポートフォリオに関連付けられます。
  # 形式: prod-xxxxxxxxxx
  # 長さ制約: 1〜100文字
  # パターン: ^[a-zA-Z0-9_\-]*
  product_id = "prod-dnigbtea24ste"

  # ------------------------------
  # オプションパラメータ
  # ------------------------------

  # 言語コード
  # AWS Service Catalogの操作に使用する言語を指定します。
  # 有効な値:
  #   - "en": 英語（デフォルト）
  #   - "jp": 日本語
  #   - "zh": 中国語
  # 長さ制約: 最大100文字
  accept_language = "en"

  # リージョン
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトで使用されます。
  # このパラメータを使用することで、プロバイダーのリージョンと異なる
  # リージョンでリソースを管理できます。
  # region = "us-west-2"

  # ソースポートフォリオID
  # 製品のコピー元となるポートフォリオの識別子を指定します。
  # 別のポートフォリオから製品を関連付ける際に使用します。
  # 形式: port-xxxxxxxxxx
  # 長さ制約: 1〜100文字
  # パターン: ^[a-zA-Z0-9_\-]*
  # source_portfolio_id = "port-source123456"

  # ------------------------------
  # タイムアウト設定
  # ------------------------------

  # リソース操作のタイムアウト値を設定します。
  timeouts {
    # 作成時のタイムアウト
    # デフォルト: 3m
    create = "3m"

    # 読み取り時のタイムアウト
    # デフォルト: 10m
    read = "10m"

    # 削除時のタイムアウト
    # デフォルト: 3m
    delete = "3m"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします（computed only）:
#
# - id: 関連付けの識別子
#       形式: <portfolio_id>:<product_id>
#
# 使用例:
#   resource.aws_servicecatalog_product_portfolio_association.example.id
#
#---------------------------------------------------------------
