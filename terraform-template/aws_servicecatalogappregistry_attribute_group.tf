#---------------------------------------------------------------
# AWS Service Catalog AppRegistry Attribute Group
#---------------------------------------------------------------
#
# AWS Service Catalog AppRegistryの属性グループを管理するリソースです。
# 属性グループは、AWSアプリケーションとそのコンポーネントを記述する
# リッチメタデータを提供します。JSONフォーマットでメタデータ分類を
# 定義し、アプリケーションに関連付けることができます。
#
# AWS公式ドキュメント:
#   - AttributeGroup API Reference: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_app-registry_AttributeGroup.html
#   - Creating attribute groups: https://docs.aws.amazon.com/servicecatalog/latest/arguide/create-attr-groups.html
#   - Viewing attribute group details: https://docs.aws.amazon.com/servicecatalog/latest/arguide/view-attr-group.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalogappregistry_attribute_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_servicecatalogappregistry_attribute_group" "example" {
  # ============================================================
  # 必須パラメータ
  # ============================================================

  # 属性グループの名前
  # - 属性グループを識別するための一意の名前
  # - 長さ: 1～256文字
  # - 使用可能文字: 英数字、ハイフン(-)、ピリオド(.)、アンダースコア(_)
  # - パターン: [-.\\w]+
  name = "example-attribute-group"

  # 属性（メタデータ）
  # - アプリケーションとそのコンポーネントを記述するメタデータ
  # - JSON文字列形式でネストされたキーバリューペアを指定
  # - 組織のメタデータ分類体系（タクソノミー）を定義
  # - 例: チーム情報、部署、連絡先エイリアスなど
  # - jsonencode()関数を使用してオブジェクトをJSON文字列に変換可能
  attributes = jsonencode({
    Team       = "engineering"
    Department = "IT"
    ParentDept = "Technology"
    Contact    = "engineering@example.com"
  })

  # ============================================================
  # オプションパラメータ
  # ============================================================

  # 説明
  # - 属性グループの説明文
  # - ユーザーが提供する属性グループの目的や用途の説明
  # - 最大長: 1024文字
  # - この説明はコンソールやAPIで表示されます
  description = "Example attribute group for application metadata management"

  # リージョン
  # - このリソースが管理されるAWSリージョン
  # - 指定しない場合、プロバイダー設定のリージョンがデフォルト使用されます
  # - リージョナルエンドポイント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # - 通常は明示的に指定する必要はありません
  # region = "us-east-1"

  # タグ
  # - 属性グループに割り当てるタグのマップ
  # - キー: 最小1文字、最大128文字
  # - 値: 最大256文字
  # - 最大50個のタグを設定可能
  # - プロバイダーのdefault_tags設定ブロックと統合されます
  # - マッチするキーのタグはプロバイダーレベルの定義を上書きします
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Purpose     = "metadata-management"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（読み取り専用）:
#
# - arn
#   属性グループのAmazon Resource Name (ARN)
#   サービス間で属性グループを特定するために使用
#   パターン: arn:aws[-a-z]*:servicecatalog:[a-z]{2}(-gov)?-[a-z]+-\d:\d{12}:/attribute-groups/[-.\w]+
#
# - id
#   属性グループのグローバル一意識別子
#   長さ: 1～256文字
#   パターン: [-.\w]+
#
# - tags_all
#   リソースに割り当てられたすべてのタグのマップ
#   プロバイダーのdefault_tags設定ブロックから継承されたタグを含みます
#
#---------------------------------------------------------------
