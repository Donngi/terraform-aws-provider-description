################################################################################
# AWS Service Catalog Principal Portfolio Association
################################################################################
# このリソースは、AWS Service Catalogポートフォリオにプリンシパル（IAMユーザー、
# グループ、ロール）を関連付けます。これにより、指定されたプリンシパルが
# ポートフォリオ内の製品にアクセスできるようになります。
#
# 【主な用途】
# - ポートフォリオへのIAMプリンシパルのアクセス権限付与
# - 複数のプリンシパルパターンによる一括アクセス制御（IAM_PATTERN使用時）
# - 組織単位でのService Catalog製品アクセス管理
#
# 【重要な注意事項】
# - IAM_PATTERNタイプを使用する場合、ワイルドカード文字（*、?）を含むARNパターンを
#   指定できますが、他のアカウントとポートフォリオを共有する際に権限昇格のリスクが
#   あるため注意が必要です
# - principal_typeを空文字列に設定するとエラーになります
#
# 【参考ドキュメント】
# - API Reference: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_AssociatePrincipalWithPortfolio.html
# - Terraform Resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_principal_portfolio_association

resource "aws_servicecatalog_principal_portfolio_association" "example" {
  ################################################################################
  # Required Parameters
  ################################################################################

  # ポートフォリオID
  # AWS Service Catalogポートフォリオの一意の識別子
  # 形式: port-xxxxxxxxxx
  # 例: "port-68656c6c6f"
  portfolio_id = "port-68656c6c6f"

  # プリンシパルARN
  # 関連付けるIAMプリンシパル（ユーザー、グループ、ロール）のARN
  # principal_typeがIAMの場合: 標準的なIAM ARN
  # principal_typeがIAM_PATTERNの場合: ワイルドカード文字（*、?）を含むARNパターン
  #
  # 【有効な形式】
  # - IAMユーザー: "arn:aws:iam::123456789012:user/Eleanor"
  # - IAMグループ: "arn:aws:iam::123456789012:group/Developers"
  # - IAMロール: "arn:aws:iam::123456789012:role/ServiceCatalogUser"
  # - パターン例: "arn:aws:iam::123456789012:user/Dev*"
  # - パターン例: "arn:aws:iam::123456789012:role/*/ServiceCatalog*"
  #
  # 【注意事項】
  # - IAM_PATTERNでワイルドカードを使用する場合、リソースタイプ（user/、group/、role/）
  #   の後のresource-idセグメントでのみ使用可能
  # - *文字は/文字にもマッチするため、resource-id内でパスを形成できます
  principal_arn = "arn:aws:iam::123456789012:user/Eleanor"

  ################################################################################
  # Optional Parameters
  ################################################################################

  # 言語コード
  # Service Catalogコンソールおよびエラーメッセージの表示言語
  # 有効な値: "en"（英語）、"jp"（日本語）、"zh"（中国語）
  # デフォルト: "en"
  accept_language = "en"

  # プリンシパルタイプ
  # 関連付けるプリンシパルのタイプを指定
  # 有効な値:
  # - "IAM": 標準のIAMプリンシパル（ユーザー、グループ、ロール）
  # - "IAM_PATTERN": ワイルドカード文字を含むIAM ARNパターン
  #
  # デフォルト: "IAM"
  #
  # 【IAM_PATTERNの使用例】
  # principal_arn = "arn:aws:iam::123456789012:user/Dev*"
  # principal_type = "IAM_PATTERN"
  # この場合、"Dev"で始まる全てのユーザーがポートフォリオにアクセス可能
  #
  # 【セキュリティ警告】
  # IAM_PATTERNを使用してポートフォリオを他のアカウントと共有する場合、
  # 意図しないプリンシパルにアクセス権限が付与される可能性があります。
  # 権限昇格のリスクがあるため、慎重に設計してください。
  #
  # 【注意】
  # 空文字列を設定するとエラーになります（principal_type = "" は無効）
  principal_type = "IAM"

  # リージョン
  # このリソースが管理されるAWSリージョン
  # 省略した場合、プロバイダー設定のリージョンが使用されます
  # 例: "us-east-1", "ap-northeast-1"
  # region = "us-east-1"

  ################################################################################
  # Attributes (Read-only)
  ################################################################################
  # 以下の属性は、リソース作成後に参照可能です:
  #
  # id - 関連付けの一意の識別子
  #   例: aws_servicecatalog_principal_portfolio_association.example.id
}

################################################################################
# 使用例: IAMグループへのアクセス付与
################################################################################
# resource "aws_servicecatalog_principal_portfolio_association" "developers" {
#   portfolio_id  = aws_servicecatalog_portfolio.main.id
#   principal_arn = "arn:aws:iam::123456789012:group/Developers"
#   principal_type = "IAM"
#   accept_language = "en"
# }

################################################################################
# 使用例: パターンマッチングによる複数ユーザーへのアクセス付与
################################################################################
# resource "aws_servicecatalog_principal_portfolio_association" "qa_team" {
#   portfolio_id  = aws_servicecatalog_portfolio.main.id
#   principal_arn = "arn:aws:iam::123456789012:user/QA-*"
#   principal_type = "IAM_PATTERN"
#   accept_language = "jp"
# }

################################################################################
# 使用例: ロールベースのアクセス制御
################################################################################
# resource "aws_servicecatalog_principal_portfolio_association" "service_role" {
#   portfolio_id  = aws_servicecatalog_portfolio.main.id
#   principal_arn = "arn:aws:iam::123456789012:role/ServiceCatalogEndUser"
#   principal_type = "IAM"
# }

################################################################################
# ベストプラクティス
################################################################################
# 1. プリンシパルタイプの選択
#    - 特定のプリンシパルにアクセスを付与する場合: IAM
#    - 命名規則に基づく複数のプリンシパルに一括でアクセスを付与する場合: IAM_PATTERN
#
# 2. IAM_PATTERNのセキュリティ
#    - 可能な限り具体的なパターンを使用する
#    - ワイルドカード（*）の使用は最小限にする
#    - クロスアカウント共有時は特に注意が必要
#
# 3. 組織的な管理
#    - IAMグループを使用してユーザーをグループ化し、グループ単位で関連付ける
#    - ロールベースのアクセス制御（RBAC）を実装する
#
# 4. 言語設定
#    - accept_languageは組織の主要言語に合わせて設定
#    - 多国籍チームの場合は英語（en）を推奨
#
# 5. リージョン管理
#    - 明示的なリージョン指定が必要な場合のみregionパラメータを使用
#    - 通常はプロバイダー設定のリージョンで管理

################################################################################
# 関連リソース
################################################################################
# - aws_servicecatalog_portfolio: ポートフォリオの作成
# - aws_servicecatalog_product_portfolio_association: 製品とポートフォリオの関連付け
# - aws_servicecatalog_portfolio_share: ポートフォリオの共有
# - aws_iam_user: IAMユーザーの管理
# - aws_iam_group: IAMグループの管理
# - aws_iam_role: IAMロールの管理
