#---------------------------------------------------------------
# AWS Service Catalog Principal Portfolio Association
#---------------------------------------------------------------
#
# AWS Service Catalogのプリンシパル（IAMユーザー・ロール・グループ）と
# ポートフォリオの関連付けをプロビジョニングするリソースです。
# この関連付けにより、指定したプリンシパルがポートフォリオおよびその中の
# 製品にアクセスできるようになります。
#
# AWS公式ドキュメント:
#   - AssociatePrincipalWithPortfolio API: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_AssociatePrincipalWithPortfolio.html
#   - ポートフォリオへのアクセス許可: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/catalogs_portfolios_users.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_principal_portfolio_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_servicecatalog_principal_portfolio_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # portfolio_id (Required)
  # 設定内容: 関連付け先のポートフォリオIDを指定します。
  # 設定可能な値: 有効なService CatalogポートフォリオID
  portfolio_id = "port-68656c6c6f"

  # principal_arn (Required)
  # 設定内容: 関連付けるプリンシパルのARNを指定します。
  # 設定可能な値: IAMユーザー・ロール・グループのARN文字列（1〜1000文字）
  #   IAM タイプの場合: アカウントIDを含む完全なARN
  #   IAM_PATTERN タイプの場合: アカウントIDなしのARN、ワイルドカード（* ?）使用可
  # 注意: principal_typeがIAM_PATTERNの場合、ARNにアカウントIDを含めないこと
  principal_arn = "arn:aws:iam::123456789012:user/Eleanor"

  #-------------------------------------------------------------
  # プリンシパルタイプ設定
  #-------------------------------------------------------------

  # principal_type (Optional)
  # 設定内容: プリンシパルのタイプを指定します。
  # 設定可能な値:
  #   - "IAM": 完全修飾ARNで指定されたIAMプリンシパル（デフォルト）
  #   - "IAM_PATTERN": アカウントIDなし・ワイルドカード付きのARNパターン
  # 省略時: "IAM" が使用されます。
  # 注意: IAM_PATTERNを使用してポートフォリオを他のアカウントと共有する場合、
  #       受信側アカウントのユーザーが主体名に一致するプリンシパルを作成することで
  #       権限昇格が発生するリスクがあります。セキュリティ上は "IAM" の使用を推奨します。
  # 参考: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_Principal.html
  principal_type = "IAM"

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

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    create = "30m"

    # read (Optional)
    # 設定内容: リソース読み取り時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "10m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    read = "10m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 関連付けの識別子。portfolio_id、principal_arn、principal_typeを
#       コンマ区切りで結合した文字列で構成されます。
#---------------------------------------------------------------
