/*
===========================================
AWS DataZone Glossary - Annotated Template
===========================================

生成日: 2026-01-19
Provider Version: 6.28.0

注意: このテンプレートは生成時点の情報に基づいています。
最新の仕様については、必ず公式ドキュメントを確認してください。

AWS Provider Documentation:
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datazone_glossary

AWS DataZone Documentation:
https://docs.aws.amazon.com/datazone/latest/userguide/create-maintain-business-glossary.html
*/

resource "aws_datazone_glossary" "example" {
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # 必須パラメータ (Required Parameters)
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # domain_identifier - DataZone ドメインの識別子
  # Amazon DataZone ドメインは、アセット、ユーザー、プロジェクトを整理するための
  # 組織エンティティです。ビジネス用語集はドメインのカタログに作成されます。
  # Type: string (required)
  # Constraints: なし
  # https://docs.aws.amazon.com/datazone/latest/userguide/datazone-concepts.html
  domain_identifier = "dzd_example123456"

  # name - ビジネス用語集の名前
  # ビジネス用語集の名前を指定します。この名前は、DataZone ポータルでの
  # 用語集の識別に使用されます。
  # Type: string (required)
  # Constraints: 長さは1〜256文字である必要があります
  # https://docs.aws.amazon.com/datazone/latest/userguide/create-maintain-business-glossary.html
  name = "example-business-glossary"

  # owning_project_identifier - 所有プロジェクトの識別子
  # このビジネス用語集を所有する DataZone プロジェクトのIDを指定します。
  # プロジェクトメンバーは、ビジネスユースケースで協力するためのグループで、
  # 用語集の作成と管理の権限を持ちます。
  # Type: string (required)
  # Constraints: ^[a-zA-Z0-9_-]{1,36}$ の正規表現に従う必要があります
  # https://docs.aws.amazon.com/datazone/latest/userguide/datazone-concepts.html
  owning_project_identifier = "abc123def456"

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # オプションパラメータ (Optional Parameters)
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # description - ビジネス用語集の説明
  # ビジネス用語集の目的や用途についての説明を記載します。
  # この説明は、DataZone ポータルでユーザーに表示され、用語集の内容を
  # 理解する助けとなります。
  # Type: string (optional)
  # Constraints: 長さは0〜4096文字である必要があります
  # Default: なし
  # https://docs.aws.amazon.com/datazone/latest/userguide/create-maintain-business-glossary.html
  description = "Business glossary for standardized terminology across the organization"

  # region - リソースを管理するリージョン
  # このリソースが管理される AWS リージョンを指定します。
  # 指定しない場合、プロバイダー設定で設定されたリージョンがデフォルトで使用されます。
  # Type: string (optional, computed)
  # Default: プロバイダー設定のリージョン
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  region = "us-east-1"

  # status - ビジネス用語集のステータス
  # ビジネス用語集の有効/無効状態を制御します。
  # DISABLED に設定すると、用語集内の全ての用語の使用が防止されます。
  # ENABLED に設定すると、用語集とその用語が使用可能になります。
  # Type: string (optional)
  # Valid Values: "DISABLED" | "ENABLED"
  # Default: "ENABLED" (推測)
  # https://docs.aws.amazon.com/datazone/latest/userguide/create-maintain-business-glossary.html
  status = "ENABLED"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Computed Attributes (出力専用属性)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 以下の属性はAWSによって自動的に計算され、Terraformの出力として参照可能です。
# テンプレートには含めません。
#
# - id (string): ビジネス用語集のID
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/*
===========================================
使用例 (Usage Example)
===========================================

基本的な使用例:

resource "aws_datazone_glossary" "sales_glossary" {
  domain_identifier         = aws_datazone_domain.example.id
  name                      = "sales-terminology"
  owning_project_identifier = aws_datazone_project.sales.id
  description               = "Standard terminology for sales and customer data"
  status                    = "ENABLED"
}

無効化された用語集の例:

resource "aws_datazone_glossary" "deprecated_glossary" {
  domain_identifier         = aws_datazone_domain.example.id
  name                      = "deprecated-terms"
  owning_project_identifier = aws_datazone_project.legacy.id
  description               = "Deprecated terminology - do not use for new assets"
  status                    = "DISABLED"
}

===========================================
補足情報 (Additional Information)
===========================================

ビジネス用語集について:
- ビジネス用語集は、ビジネス用語とその定義のコレクションです
- データ分析時に組織全体で一貫した用語の使用を保証します
- 用語集はカタログドメインに作成され、アセットやカラムに適用できます
- 用語集は階層構造を持つことができ、用語は他の用語のサブリストと関連付けられます
- 所有プロジェクトで適切な権限を持つユーザーのみが用語集を編集できます

ステータスについて:
- DISABLED: 用語集とその中の全ての用語の使用を防止します
- ENABLED: 用語集と用語が使用可能な状態です

関連リソース:
- aws_datazone_domain: DataZone ドメインの作成
- aws_datazone_project: DataZone プロジェクトの作成
- aws_datazone_glossary_term: 用語集内の用語の作成

参考リンク:
- Amazon DataZone Business Glossary Concepts:
  https://docs.aws.amazon.com/datazone/latest/userguide/datazone-concepts.html
- Creating a Business Glossary:
  https://docs.aws.amazon.com/datazone/latest/userguide/create-maintain-business-glossary.html
- Editing a Business Glossary:
  https://docs.aws.amazon.com/datazone/latest/userguide/edit-business-glossary.html
*/
