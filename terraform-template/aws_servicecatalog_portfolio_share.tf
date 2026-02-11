#---------------------------------------------------------------
# Service Catalog ポートフォリオ共有
#---------------------------------------------------------------
#
# Service Catalogポートフォリオを他のAWSアカウントまたは組織ノード
# （組織、組織単位、特定のアカウント）と共有するためのリソースです。
# ポートフォリオを共有することで、受信者は製品をエンドユーザーに
# 配布できるようになります。
#
# AWS公式ドキュメント:
#   - Sharing a Portfolio: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/catalogs_portfolios_sharing_how-to-share.html
#   - CreatePortfolioShare API: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_CreatePortfolioShare.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_portfolio_share
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
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
  # 設定可能な値: 有効なService Catalogポートフォリオのポートフォリオ識別子
  # 参考: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/catalogs_portfolios.html
  portfolio_id = "port-1234567890abc"

  # principal_id (Required)
  # 設定内容: ポートフォリオを共有する相手の識別子を指定します。
  # 設定可能な値:
  #   - AWSアカウントID (例: "012345678901")
  #   - AWS OrganizationsのARN (例: "arn:aws:organizations::123456789012:organization/o-xxxxx")
  #   - 組織単位のARN (例: "arn:aws:organizations::123456789012:ou/o-xxxxx/ou-xxxxx")
  # 注意: typeパラメータと組み合わせて使用します。
  # 参考: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/catalogs_portfolios_sharing_how-to-share.html
  principal_id = "012345678901"

  # type (Required)
  # 設定内容: ポートフォリオ共有のタイプを指定します。
  # 設定可能な値:
  #   - "ACCOUNT": 外部アカウントへの共有（アカウント間共有）
  #   - "ORGANIZATION": 組織内の全アカウントへの共有
  #   - "ORGANIZATIONAL_UNIT": 組織単位への共有
  #   - "ORGANIZATION_MEMBER_ACCOUNT": 組織内のアカウントへの共有
  # 注意: 組織ノードへの共有は、組織の管理アカウントまたは委任された管理者のみが作成できます。
  # 参考: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/catalogs_portfolios_sharing_how-to-share.html
  type = "ACCOUNT"

  #-------------------------------------------------------------
  # ローカライゼーション設定
  #-------------------------------------------------------------

  # accept_language (Optional)
  # 設定内容: APIリクエストで使用する言語コードを指定します。
  # 設定可能な値:
  #   - "en": 英語（デフォルト）
  #   - "jp": 日本語
  #   - "zh": 中国語
  # 省略時: "en"
  accept_language = "en"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースが管理されるリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: ポートフォリオのインポートは、管理アカウントと依存アカウント間で同じリージョンで行う必要があります。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #-------------------------------------------------------------
  # 共有オプション設定
  #-------------------------------------------------------------

  # share_principals (Optional)
  # 設定内容: ポートフォリオ共有を作成する際にプリンシパル共有を有効化するかどうかを指定します。
  # 設定可能な値:
  #   - true: プリンシパル共有を有効化
  #   - false: プリンシパル共有を無効化（デフォルト）
  # 省略時: false（プリンシパル共有は無効）
  # 関連機能: Principal Name Sharing
  #   プリンシパル名（グループ、ロール、ユーザーの名前）をポートフォリオで指定し、
  #   ポートフォリオと共に共有できます。ポートフォリオが共有されると、Service Catalogは
  #   受信アカウントにそれらのプリンシパル名が既に存在するかを確認し、存在する場合は
  #   自動的に一致するIAMプリンシパルを共有ポートフォリオに関連付けます。
  #   - https://docs.aws.amazon.com/servicecatalog/latest/adminguide/catalogs_portfolios_sharing_how-to-share.html
  # 注意: AWS Organizationsでのみ利用可能です。
  # share_principals = true

  # share_tag_options (Optional)
  # 設定内容: ポートフォリオ共有を作成する際にTagOptionリソースの共有を有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true: TagOption共有を有効化
  #   - false: TagOption共有を無効化（デフォルト）
  # 省略時: false（TagOption共有は無効）
  # 関連機能: TagOptions Sharing
  #   TagOptionsは、管理者がタグの分類を定義・強制し、製品やポートフォリオに関連付けることが
  #   できるキーと値のペアです。メインアカウントでTagOptionsを追加または削除すると、
  #   変更は受信アカウントに自動的に反映されます。
  #   - https://docs.aws.amazon.com/servicecatalog/latest/adminguide/catalogs_portfolios_sharing_how-to-share.html
  # share_tag_options = true

  #-------------------------------------------------------------
  # 受け入れ設定
  #-------------------------------------------------------------

  # wait_for_acceptance (Optional)
  # 設定内容: 共有が受け入れられるまで（タイムアウトまで）待機するかどうかを指定します。
  # 設定可能な値:
  #   - true: 受け入れを待機
  #   - false: 受け入れを待機しない（デフォルト）
  # 省略時: false（待機しない）
  # 注意: 組織共有は自動的に受け入れられます。アカウント間共有の場合、受信側が明示的に受け入れる必要があります。
  # wait_for_acceptance = true

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウトを設定します。
  # 設定可能な値:
  #   - create: 作成時のタイムアウト（文字列、例: "30m"）
  #   - read: 読み取り時のタイムアウト（文字列、例: "10m"）
  #   - update: 更新時のタイムアウト（文字列、例: "30m"）
  #   - delete: 削除時のタイムアウト（文字列、例: "30m"）
  # 省略時: Terraformのデフォルトタイムアウト値を使用
  # 注意: デフォルトのタイムアウト値が長すぎる、または短すぎる場合に調整します。
  # timeouts {
  #   create = "30m"
  #   read   = "10m"
  #   update = "30m"
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの一意識別子。
#       形式: "portfolio_id:type:principal_id"
#       Terraformによって自動的に生成されます。
#
# - accepted: 共有されたポートフォリオが受信側アカウントによってインポート
#             されたかどうかを示します。受信側が組織の場合、共有は自動的に
#             インポートされ、このフィールドは常にtrueに設定されます。
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: アカウント間でのポートフォリオ共有
resource "aws_servicecatalog_portfolio_share" "account_share" {
  portfolio_id = aws_servicecatalog_portfolio.example.id
  principal_id = "012345678901"
  type         = "ACCOUNT"
}

# 例2: 組織全体へのポートフォリオ共有（TagOptions共有を有効化）
resource "aws_servicecatalog_portfolio_share" "org_share" {
  portfolio_id      = aws_servicecatalog_portfolio.example.id
  principal_id      = "o-exampleorgid"
  type              = "ORGANIZATION"
  share_tag_options = true
}

# 例3: 組織単位へのポートフォリオ共有（プリンシパル共有を有効化）
resource "aws_servicecatalog_portfolio_share" "ou_share" {
  portfolio_id     = aws_servicecatalog_portfolio.example.id
  principal_id     = "ou-exampleouid"
  type             = "ORGANIZATIONAL_UNIT"
  share_principals = true
}

# 例4: アカウント間共有で受け入れ待機
resource "aws_servicecatalog_portfolio_share" "account_share_with_wait" {
  portfolio_id        = aws_servicecatalog_portfolio.example.id
  principal_id        = "012345678901"
  type                = "ACCOUNT"
  wait_for_acceptance = true

  timeouts {
    create = "60m"
  }
}
