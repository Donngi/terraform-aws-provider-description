#---------------------------------------------------------------
# AWS Lake Formation LF Tag Expression
#---------------------------------------------------------------
#
# AWS Lake Formationのタグ式(LF Tag Expression)をプロビジョニングするリソースです。
# LF Tag Expressionは、複数のLF-Tagのキーと値のペアを組み合わせた論理式を作成し、
# Lake Formationのリソースやデータカタログに対するアクセス制御を柔軟に定義できます。
#
# AWS公式ドキュメント:
#   - Lake Formation概要: https://docs.aws.amazon.com/lake-formation/latest/dg/what-is-lake-formation.html
#   - LF-Tagsとタグベースのアクセス制御: https://docs.aws.amazon.com/lake-formation/latest/dg/tag-based-access-control.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_lf_tag_expression
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lakeformation_lf_tag_expression" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: LF-Tag Expressionの名前を指定します。
  # 設定可能な値: 1文字以上の文字列
  # 注意: わかりやすく、目的を明確に示す命名を推奨します
  name = "example-tag-expression"

  # description (Optional)
  # 設定内容: LF-Tag Expressionの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: タグ式の目的や適用範囲を記述し、管理を容易にします
  description = "Example LF-Tag Expression for data access control"

  #-------------------------------------------------------------
  # データカタログ設定
  #-------------------------------------------------------------

  # catalog_id (Optional)
  # 設定内容: Data CatalogのIDを指定します。
  # 設定可能な値: AWSアカウントID
  # 省略時: 現在のアカウントIDが使用されます
  # 注意: クロスアカウントでのカタログ管理が必要な場合に指定します
  catalog_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ式設定 (expression)
  #-------------------------------------------------------------

  # expression (Required)
  # 設定内容: LF-Tag条件（キーと値のペア）のリストを指定します。
  # 用途: アクセス制御の対象となるリソースを識別するためのタグ条件を定義します
  # 注意: 複数のexpressionブロックを指定可能で、それらはAND条件として評価されます
  expression {
    # tag_key (Required)
    # 設定内容: LF-Tagのキー名を指定します。
    # 設定可能な値: 既存のLF-Tagキー名（aws_lakeformation_lf_tagで定義）
    # 関連リソース: aws_lakeformation_lf_tag
    # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_lf_tag
    tag_key = "Environment"

    # tag_values (Required)
    # 設定内容: LF-Tagの値のリストを指定します。
    # 設定可能な値: tag_keyに対応する値のセット
    # 注意: 複数の値を指定した場合、OR条件として評価されます
    # 例: ["Production", "Staging"]の場合、EnvironmentがProductionまたはStagingのリソースが対象
    tag_values = ["Production", "Development"]
  }

  # 複数のタグ条件を組み合わせる例
  # 注意: 複数のexpressionブロックを指定すると、すべての条件を満たす必要があります（AND条件）
  expression {
    # tag_key (Required)
    # 設定内容: 2つ目のLF-Tagのキー名を指定します。
    tag_key = "DataClassification"

    # tag_values (Required)
    # 設定内容: データ分類レベルを示す値のリストを指定します。
    # 用途: 機密性レベルに基づくアクセス制御を実現します
    tag_values = ["Confidential", "Internal"]
  }
}

#---------------------------------------------------------------
# LF Tag Expressionは、通常、以下のリソースと組み合わせて使用します:
#
# 1. aws_lakeformation_lf_tag
#    - LF-Tagのキーと値を定義します
#    - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_lf_tag
#
# 2. aws_lakeformation_permissions
#    - タグベースのアクセス制御を設定します
#    - LF Tag Expressionを使用して、きめ細かなアクセス権限を付与できます
#    - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_permissions
#
# 3. aws_glue_catalog_database / aws_glue_catalog_table
#    - データカタログリソースにLF-Tagを適用します
#    - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_database
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 1. タグ設計の一貫性
#    - 組織全体で一貫したLF-Tagの命名規則を採用する
#    - Environment、DataClassification、ProjectNameなどの標準タグを定義
#
# 2. 最小権限の原則
#    - 必要最小限のタグ式を使用してアクセスを制限する
#    - 複数の条件を組み合わせて、きめ細かな制御を実現
#
# 3. ドキュメント化
#    - descriptionフィールドを活用して、タグ式の目的を明確に記述する
#    - タグ式がどのリソースに適用されるかをコメントに記載
#
# 4. テストとバリデーション
#    - タグ式を適用する前に、対象リソースが正しく識別されることを確認する
#    - Lake Formation権限設定との整合性を検証
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは明示的にエクスポートされる属性はありませんが、
# 以下の標準的な参照が可能です:
#
# - id: リソースの識別子（nameと同じ値）
#
# - name: LF-Tag Expressionの名前（入力値がそのまま参照可能）
#
# - catalog_id: Data CatalogのID（入力値または自動設定された値）
#
# - region: リージョン（入力値またはプロバイダー設定の値）
#---------------------------------------------------------------
