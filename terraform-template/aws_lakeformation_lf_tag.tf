#---------------------------------------------------------------
# AWS Lake Formation LF-Tag
#---------------------------------------------------------------
#
# LF-Tagリソースを作成し、Lake Formationのタグベースアクセス制御（LF-TBAC）で
# データカタログリソース（データベース、テーブル、カラム）へのアクセス制御を
# 実現します。各LF-Tagはキーと値のペアで構成され、最大1000個の値を持つことができます。
#
# LF-Tagsを使用することで、データレイク管理者は細かい粒度でのアクセス制御を
# 実装でき、リソースに対してタグを割り当て、プリンシパル（ユーザー・ロール）に
# タグベースの権限を付与できます。
#
# AWS公式ドキュメント:
#   - Managing LF-Tags for metadata access control: https://docs.aws.amazon.com/lake-formation/latest/dg/managing-tags.html
#   - Lake Formation tag-based access control best practices: https://docs.aws.amazon.com/lake-formation/latest/dg/lf-tag-considerations.html
#   - Assigning LF-Tags to Data Catalog resources: https://docs.aws.amazon.com/lake-formation/latest/dg/TBAC-assigning-tags.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_lf_tag
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lakeformation_lf_tag" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # key - (Required) LF-Tagのキー名
  # Lake Formationで使用するタグのキー名を指定します。
  # このキーは、データカタログリソース（データベース、テーブル、カラム）に
  # 割り当てられるタグの識別子として使用されます。
  #
  # 制約:
  #   - 最大50文字まで
  #   - 小文字に変換されます
  #   - 同一アカウント内でユニークである必要があります
  #
  # 例: "module", "environment", "classification", "department"
  key = "module"

  # values - (Required) LF-Tagキーに対する取りうる値のリスト
  # このLF-Tagキーに割り当て可能な値のセットを定義します。
  # リソースにタグを割り当てる際は、このリストから1つの値を選択します。
  #
  # 制約:
  #   - 各値は最大50文字まで
  #   - 1つのキーに対して最大1000個の値を設定可能
  #   - 値は小文字に変換されます
  #   - 各値はキー内でユニークである必要があります
  #
  # 例: ["Orders", "Sales", "Customers"] または ["dev", "staging", "prod"]
  values = ["Orders", "Sales", "Customers"]

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # catalog_id - (Optional) LF-Tagを作成するData CatalogのID
  # Lake Formation LF-Tagを作成する対象のAWSアカウントのData Catalog IDを指定します。
  # 省略した場合は、現在のAWSアカウントIDがデフォルトで使用されます。
  #
  # クロスアカウントでのLF-Tag管理を行う場合に指定が必要です。
  # ただし、LF-TagsとリソースはAWS公式ベストプラクティスにより、
  # 同一アカウント内でのみ使用可能です。
  #
  # 型: string
  # デフォルト: 現在のAWSアカウントID
  # 例: "123456789012"
  # catalog_id = "123456789012"

  # id - (Optional) LF-Tagのリソース識別子
  # Terraformによって管理されるリソースIDです。
  # 通常は明示的に設定する必要はなく、Terraformが自動的に生成・管理します。
  #
  # このIDは "catalog_id:key" の形式で構成されます。
  # 主にインポート時や、他のリソースからの参照時に使用されます。
  #
  # 型: string
  # computed: true
  # 例: "123456789012:module"
  # id = null

  # region - (Optional) このリソースが管理されるAWSリージョン
  # LF-Tagを作成・管理するAWSリージョンを明示的に指定します。
  # 省略した場合は、プロバイダー設定で指定されたリージョンが使用されます。
  #
  # マルチリージョン構成でリソースを管理する場合に有用です。
  #
  # 型: string
  # デフォルト: プロバイダー設定のリージョン
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 例: "us-east-1", "ap-northeast-1"
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed値）:
#
# - id
#   Catalog IDとキー名で構成されるLF-Tagの識別子
#   形式: "{catalog_id}:{key}"
#   例: "123456789012:module"
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のLF-Tagは以下の形式でインポート可能:
#
# terraform import aws_lakeformation_lf_tag.example catalog_id:key
#
# 例:
# terraform import aws_lakeformation_lf_tag.example 123456789012:module
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# LF-Tag使用のベストプラクティス
#---------------------------------------------------------------
#
# 1. タグ設計の計画
#    - LF-Tagsは事前定義が必要です（リソース作成時に同時割り当て不可）
#    - データガバナンス要件に基づいた体系的なタグ体系を設計
#    - 例: 部署（department）、機密度（classification）、プロジェクト（project）
#
# 2. LF-Tag制約の理解
#    - アカウントごとに最大1000個のLF-Tagsを作成可能（ソフトリミット）
#    - 1つのLF-Tagキーに対して最大1000個の値を設定可能
#    - 1つのリソースに対して最大50個のLF-Tagsを割り当て可能
#    - LF-Tagキーと値は最大50文字まで
#
# 3. アクセス制御の実装
#    - LF-Tag式を使用して、複数タグの組み合わせで権限を付与
#    - 同一キーの複数値はOR条件、異なるキーはAND条件として評価
#    - LF-Tag式は最大1000個まで作成可能
#
# 4. ライフサイクル管理
#    - LF-Tag作成者またはデータレイク管理者のみが作成・更新・削除可能
#    - タグ管理タスクをLF-Tag作成者に委任可能
#    - 使用されなくなったLF-Tagsの定期的なレビューと削除
#
# 5. クロスアカウント共有
#    - LF-TabsはRAM（Resource Access Manager）を使用してクロスアカウント共有可能
#    - 共有前に適切なDescribe/Associate権限を外部アカウントに付与
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 関連リソース
#---------------------------------------------------------------
# - aws_lakeformation_permissions: LF-Tagを使用した権限付与
# - aws_lakeformation_resource: Lake Formationリソース登録
# - aws_lakeformation_resource_lf_tags: リソースへのLF-Tag割り当て
# - aws_glue_catalog_database: データベースリソース（LF-Tag割り当て対象）
# - aws_glue_catalog_table: テーブルリソース（LF-Tag割り当て対象）
#---------------------------------------------------------------
