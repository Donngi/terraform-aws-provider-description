#---------------------------------------------------------------
# AWS Service Catalog Product Portfolio Association
#---------------------------------------------------------------
#
# AWS Service Catalogのプロダクトとポートフォリオの関連付けを管理するリソースです。
# プロダクトをポートフォリオに関連付けることで、エンドユーザーが
# ポートフォリオを通じてプロダクトにアクセスできるようになります。
# 1つのプロダクトを複数のポートフォリオに関連付けることが可能です。
#
# AWS公式ドキュメント:
#   - AssociateProductWithPortfolio API: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_AssociateProductWithPortfolio.html
#   - ポートフォリオへのプロダクト追加: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/portfoliomgmt-products.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_product_portfolio_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_servicecatalog_product_portfolio_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # portfolio_id (Required)
  # 設定内容: 関連付け先のポートフォリオIDを指定します。
  # 設定可能な値: 有効なService Catalogポートフォリオの識別子（例: port-xxxxxxxxxx）
  portfolio_id = "port-68656c6c6f"

  # product_id (Required)
  # 設定内容: 関連付けるプロダクトIDを指定します。
  # 設定可能な値: 有効なService Catalogプロダクトの識別子（例: prod-xxxxxxxxxx）
  product_id = "prod-dnigbtea24ste"

  #-------------------------------------------------------------
  # 言語設定
  #-------------------------------------------------------------

  # accept_language (Optional)
  # 設定内容: APIレスポンスの言語コードを指定します。
  # 設定可能な値:
  #   - "en": 英語（デフォルト）
  #   - "jp": 日本語
  #   - "zh": 中国語
  # 省略時: "en"（英語）が使用されます。
  accept_language = "jp"

  #-------------------------------------------------------------
  # ソースポートフォリオ設定
  #-------------------------------------------------------------

  # source_portfolio_id (Optional)
  # 設定内容: プロダクトのインポート元となるソースポートフォリオのIDを指定します。
  # 設定可能な値: 有効なService Catalogポートフォリオの識別子
  # 省略時: ソースポートフォリオを指定しません。
  # 参考: 別アカウントやOrganizationsで共有されたポートフォリオからプロダクトを
  #       インポートする場合に使用します。
  #   - https://docs.aws.amazon.com/servicecatalog/latest/adminguide/catalogs_portfolios_sharing_how-to-share.html
  source_portfolio_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "1h" 等のGoのtime.Duration形式の文字列
    # 省略時: 3分（3m）
    create = "3m"

    # read (Optional)
    # 設定内容: リソース読み取り時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "1h" 等のGoのtime.Duration形式の文字列
    # 省略時: 10分（10m）
    read = "10m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "1h" 等のGoのtime.Duration形式の文字列
    # 省略時: 3分（3m）
    delete = "3m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 関連付けの識別子（accept_language、portfolio_id、product_idで構成）
#---------------------------------------------------------------
