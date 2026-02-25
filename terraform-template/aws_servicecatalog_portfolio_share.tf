#---------------------------------------------------------------
# AWS Service Catalog Portfolio Share
#---------------------------------------------------------------
#
# AWS Service Catalogのポートフォリオを別のAWSアカウントまたは
# AWS Organizationsのノード（組織、組織単位）と共有するリソースです。
# ポートフォリオを共有することで、受信側アカウントのエンドユーザーが
# そのポートフォリオ内のプロダクトをプロビジョニングできるようになります。
#
# AWS公式ドキュメント:
#   - ポートフォリオの共有: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/catalogs_portfolios_sharing_how-to-share.html
#   - CreatePortfolioShare API: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_CreatePortfolioShare.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_portfolio_share
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_servicecatalog_portfolio_share" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # portfolio_id (Required)
  # 設定内容: 共有するポートフォリオの識別子を指定します。
  # 設定可能な値: 有効なService CatalogポートフォリオID
  portfolio_id = "port-xxxxxxxxxxxxxxxxx"

  # principal_id (Required)
  # 設定内容: ポートフォリオを共有する対象のプリンシパル識別子を指定します。
  # 設定可能な値:
  #   - AWSアカウントID（例: "012345678901"）: typeが"ACCOUNT"の場合
  #   - AWS OrganizationsのARN: typeが"ORGANIZATION"または"ORGANIZATIONAL_UNIT"の場合
  #   - メンバーアカウントID: typeが"ORGANIZATION_MEMBER_ACCOUNT"の場合
  principal_id = "012345678901"

  # type (Required)
  # 設定内容: ポートフォリオ共有の種類を指定します。
  # 設定可能な値:
  #   - "ACCOUNT": 外部アカウントとの共有
  #   - "ORGANIZATION": 組織内の全アカウントへの共有
  #   - "ORGANIZATIONAL_UNIT": 特定の組織単位への共有
  #   - "ORGANIZATION_MEMBER_ACCOUNT": 組織内の特定メンバーアカウントへの共有
  # 注意: "ORGANIZATION"、"ORGANIZATIONAL_UNIT"、"ORGANIZATION_MEMBER_ACCOUNT"は
  #       管理アカウントまたは委任管理者アカウントからのみ実行可能です。
  #       AWS Organizations連携（AWSOrganizationsAccess）が有効になっている必要があります。
  type = "ACCOUNT"

  #-------------------------------------------------------------
  # 言語設定
  #-------------------------------------------------------------

  # accept_language (Optional)
  # 設定内容: APIリクエストで使用する言語コードを指定します。
  # 設定可能な値:
  #   - "en": 英語（デフォルト）
  #   - "jp": 日本語
  #   - "zh": 中国語
  # 省略時: "en"（英語）が使用されます。
  accept_language = "en"

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
  # 共有オプション設定
  #-------------------------------------------------------------

  # share_principals (Optional)
  # 設定内容: ポートフォリオ共有時にプリンシパル名の共有を有効にするかを指定します。
  # 設定可能な値:
  #   - true: プリンシパル名の共有を有効化。受信側アカウントで一致するIAMプリンシパルに
  #           自動的にポートフォリオへのアクセスが付与されます。
  #   - false: プリンシパル名の共有を無効化
  # 省略時: プリンシパル名の共有は無効になります。
  # 注意: この機能はAWS Organizationsとの共有でのみ利用可能です。
  share_principals = false

  # share_tag_options (Optional)
  # 設定内容: ポートフォリオ共有時にTagOptionリソースを共有するかを指定します。
  # 設定可能な値:
  #   - true: aws_servicecatalog_tag_optionリソースの共有を有効化
  #   - false: TagOptionリソースの共有を無効化
  # 省略時: TagOptionリソースの共有は無効になります。
  # 関連機能: AWS Service Catalog TagOptions
  #   管理者がタグの分類体系を定義・強制するためのキーと値のペア。
  #   ポートフォリオ共有時に受信側アカウントにTagOptionを共有可能。
  share_tag_options = false

  #-------------------------------------------------------------
  # 承認待ち設定
  #-------------------------------------------------------------

  # wait_for_acceptance (Optional)
  # 設定内容: ポートフォリオ共有が承認されるまで待機するかを指定します。
  # 設定可能な値:
  #   - true: 共有が承認されるまでタイムアウト時間まで待機します。
  #   - false: 承認を待機せずに処理を完了します。
  # 省略時: 承認を待機しません。
  # 注意: Organizationsを経由した共有は自動的に承認されるため、
  #       wait_for_acceptanceは主にACCOUNT共有で有効です。
  wait_for_acceptance = false

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

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    update = "30m"

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
# - accepted: 共有されたポートフォリオが受信側アカウントにインポートされたかどうか。
#             受信側がOrganizationsノードの場合は共有が自動的にインポートされ、
#             常にtrueになります。
#---------------------------------------------------------------
