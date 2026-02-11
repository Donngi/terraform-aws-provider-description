#---------------------------------------------------------------
# AWS Service Catalog Portfolio
#---------------------------------------------------------------
#
# AWS Service Catalog のポートフォリオを作成・管理するリソースです。
# ポートフォリオは、承認されたIT製品(CloudFormationテンプレート)の
# コレクションで、組織内のユーザーがデプロイできるリソースを
# 管理するために使用されます。
#
# ポートフォリオの主な用途:
#   1. 製品管理: 承認された製品のカタログを作成
#   2. アクセス制御: ユーザー/グループ/ロールに製品へのアクセス権限を付与
#   3. ガバナンス: 組織のコンプライアンス基準に準拠した製品のみを提供
#   4. セルフサービス: ユーザーが承認済みリソースを自分でプロビジョニング可能
#
# AWS公式ドキュメント:
#   - Service Catalog ポートフォリオ管理: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/catalogs_portfolios.html
#   - Service Catalog 概要: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/catalogs.html
#   - ポートフォリオの作成と削除: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/portfoliomgmt-create.html
#   - Service Catalog API リファレンス: https://docs.aws.amazon.com/code-library/latest/ug/cli_2_service-catalog_code_examples.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_portfolio
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_servicecatalog_portfolio" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ポートフォリオの名前を指定します。
  # 設定可能な値: 文字列 (最大100文字)
  # 用途: ポートフォリオを識別するための名前
  # 関連機能: Service Catalog ポートフォリオ管理
  #   管理者とユーザーがポートフォリオを識別するための表示名。
  #   わかりやすく、組織の命名規則に準拠した名前を使用することを推奨。
  #   - https://docs.aws.amazon.com/servicecatalog/latest/adminguide/portfoliomgmt-create.html
  name = "My App Portfolio"

  # description (Required)
  # 設定内容: ポートフォリオの説明を指定します。
  # 設定可能な値: 文字列 (最大2000文字)
  # 用途: ポートフォリオの目的や含まれる製品の種類を説明
  # 関連機能: Service Catalog ポートフォリオの説明
  #   ユーザーがポートフォリオの内容を理解するための説明文。
  #   どのような製品が含まれているか、誰が使用すべきかなどを記載。
  #   - https://docs.aws.amazon.com/servicecatalog/latest/adminguide/catalogs_portfolios.html
  description = "List of my organizations apps"

  # provider_name (Required)
  # 設定内容: ポートフォリオの所有者または管理者の名前を指定します。
  # 設定可能な値: 文字列 (個人名、チーム名、組織名など)
  # 用途: ポートフォリオを管理する個人または組織を識別
  # 関連機能: Service Catalog ポートフォリオ管理
  #   ポートフォリオの責任者を明確にし、問い合わせ先を示すために使用。
  #   組織内でのガバナンスとアカウンタビリティを強化。
  #   - https://docs.aws.amazon.com/servicecatalog/latest/adminguide/catalogs_portfolios.html
  provider_name = "Platform Engineering Team"

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 用途: リソースをデプロイするリージョンを明示的に指定する場合に使用
  # 関連機能: AWS リージョナルサービス
  #   Service Catalogはリージョナルサービスのため、各リージョンで個別に設定が必要。
  #   マルチリージョン展開時は各リージョンでポートフォリオを作成。
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ (最大50個のタグ)
  # 用途: リソースの分類、コスト管理、アクセス制御に使用
  # 関連機能: AWS リソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   タグを使用してコスト配分、リソース管理、アクセス制御を実現可能。
  #   - https://docs.aws.amazon.com/servicecatalog/latest/adminguide/catalogs_portfolios.html
  tags = {
    Name        = "my-app-portfolio"
    Environment = "production"
    Owner       = "platform-team"
    ManagedBy   = "terraform"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  # 関連機能: AWS プロバイダーのdefault_tags
  #   プロバイダーレベルで定義されたデフォルトタグと、リソース固有のタグを結合。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID (ポートフォリオID)
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  # 用途: 他のリソース(製品、制約、アクセス権限など)との関連付けに使用
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Service Catalog ポートフォリオのID
#   他のService Catalogリソース(aws_servicecatalog_product_portfolio_association、
#   aws_servicecatalog_principal_portfolio_association など)で参照可能
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#
#---------------------------------------------------------------
# 使用例: ポートフォリオへの製品追加
#---------------------------------------------------------------
# ポートフォリオ作成後は、以下のリソースを使用して製品やアクセス権限を追加:
#
# 1. 製品の関連付け:
#    resource "aws_servicecatalog_product_portfolio_association" "example" {
#      product_id   = aws_servicecatalog_product.example.id
#      portfolio_id = aws_servicecatalog_portfolio.example.id
#    }
#
# 2. ユーザー/グループ/ロールへのアクセス権限付与:
#    resource "aws_servicecatalog_principal_portfolio_association" "example" {
#      portfolio_id  = aws_servicecatalog_portfolio.example.id
#      principal_arn = "arn:aws:iam::123456789012:role/MyRole"
#    }
#
# 3. ポートフォリオ共有 (組織間またはアカウント間):
#    resource "aws_servicecatalog_portfolio_share" "example" {
#      portfolio_id = aws_servicecatalog_portfolio.example.id
#      principal_id = "123456789012"  # 共有先のAWSアカウントID
#      type         = "ACCOUNT"
#    }
#
# 4. TagOption の関連付け:
#    resource "aws_servicecatalog_tag_option_resource_association" "example" {
#      resource_id  = aws_servicecatalog_portfolio.example.id
#      tag_option_id = aws_servicecatalog_tag_option.example.id
#    }
#
# 5. 制約の追加 (起動制約、テンプレート制約など):
#    resource "aws_servicecatalog_constraint" "example" {
#      portfolio_id = aws_servicecatalog_portfolio.example.id
#      product_id   = aws_servicecatalog_product.example.id
#      type         = "LAUNCH"
#      parameters   = jsonencode({
#        RoleArn = "arn:aws:iam::123456789012:role/ServiceCatalogLaunchRole"
#      })
#    }
#
#---------------------------------------------------------------
# ポートフォリオ削除の注意事項
#---------------------------------------------------------------
# ポートフォリオを削除する前に、以下を全て削除する必要があります:
#   - 関連付けられた製品
#   - 制約
#   - グループ/ロール/ユーザーのアクセス権限
#   - ポートフォリオ共有
#   - TagOption の関連付け
#
# インポートされた(共有された)ポートフォリオは削除できませんが、
# アカウントから削除することは可能です。
#
# 参考: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/portfoliomgmt-create.html
#---------------------------------------------------------------
# AWS Organizations との統合
#---------------------------------------------------------------
# Service Catalog を AWS Organizations と統合することで、
# 組織全体でポートフォリオと製品を共有することが簡素化されます。
#
# 利点:
#   - 組織ツリー内の任意の OU (組織単位) とポートフォリオを共有可能
#   - ポートフォリオ ID を共有する必要がなくなる
#   - 一元的なガバナンスとコンプライアンス管理
#
# 信頼されたアクセスの有効化:
#   サービスプリンシパル: servicecatalog.amazonaws.com
#
# 参考: https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-servicecatalog.html
#---------------------------------------------------------------
