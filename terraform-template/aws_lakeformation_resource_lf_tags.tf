#---------------------------------------------------------------
# AWS Lake Formation リソース LF-タグ アタッチメント
#---------------------------------------------------------------
#
# 既存のLF-タグと既存のLake Formationリソース（データベース、テーブル、
# テーブル列）の間のアタッチメントを管理するリソースです。
# LF-タグベースのアクセス制御（TBAC）を実現するために使用します。
#
# AWS公式ドキュメント:
#   - Lake Formation タグベースアクセス制御: https://docs.aws.amazon.com/lake-formation/latest/dg/tag-based-access-control.html
#   - LF-タグ: https://docs.aws.amazon.com/lake-formation/latest/dg/TBAC-using-LF-tags.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_resource_lf_tags
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lakeformation_resource_lf_tags" "example" {
  #-------------------------------------------------------------
  # カタログ設定
  #-------------------------------------------------------------

  # catalog_id (Optional)
  # 設定内容: Data Catalogの識別子を指定します。
  # 設定可能な値: 有効なAWSアカウントID（12桁の数字）
  # 省略時: 呼び出し元のアカウントIDが使用されます。
  # 注意: Data CatalogはLake Formation環境を管理するための永続的なメタデータストアです。
  catalog_id = null

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
  # LF-タグ設定
  #-------------------------------------------------------------

  # lf_tag (Required, 1個以上指定)
  # 設定内容: リソースにアタッチするLF-タグの設定ブロックです。
  #           複数のlf_tagブロックを記述することで複数のタグをアタッチできます。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/TBAC-using-LF-tags.html
  lf_tag {

    # key (Required)
    # 設定内容: 既存のLF-タグのキー名を指定します。
    # 設定可能な値: 事前にaws_lakeformation_lf_tagで作成済みのキー文字列
    key = "environment"

    # value (Required)
    # 設定内容: LF-タグの設定可能な値から1つを指定します。
    # 設定可能な値: 対象LF-タグのvaluesリストに含まれる文字列
    value = "production"

    # catalog_id (Optional)
    # 設定内容: LF-タグが属するData Catalogの識別子を指定します。
    # 設定可能な値: 有効なAWSアカウントID（12桁の数字）
    # 省略時: 呼び出し元のアカウントIDが使用されます。
    catalog_id = null
  }

  #-------------------------------------------------------------
  # タグ付け対象リソース設定
  #-------------------------------------------------------------
  # database、table、table_with_columnsのいずれか1つを指定してください。

  # database (Optional)
  # 設定内容: LF-タグをアタッチするデータベースリソースの設定ブロックです。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/aws-lake-formation-api-tagging-api.html
  database {

    # name (Required)
    # 設定内容: データベースリソースの名前を指定します。
    # 設定可能な値: Data Catalog内で一意のデータベース名文字列
    name = "example_database"

    # catalog_id (Optional)
    # 設定内容: データベースが属するData Catalogの識別子を指定します。
    # 設定可能な値: 有効なAWSアカウントID（12桁の数字）
    # 省略時: 呼び出し元のアカウントIDが使用されます。
    catalog_id = null
  }

  # table (Optional)
  # 設定内容: LF-タグをアタッチするテーブルリソースの設定ブロックです。
  #           nameまたはwildcardのいずれか一方を指定してください。
  # table {
  #
  #   # database_name (Required)
  #   # 設定内容: テーブルが属するデータベースの名前を指定します。
  #   # 設定可能な値: Data Catalog内で一意のデータベース名文字列
  #   database_name = "example_database"
  #
  #   # name (Optional)
  #   # 設定内容: テーブルリソースの名前を指定します。
  #   # 設定可能な値: データベース内のテーブル名文字列
  #   # 注意: nameとwildcardのどちらか一方が必須です。
  #   name = "example_table"
  #
  #   # wildcard (Optional)
  #   # 設定内容: データベース配下のすべてのテーブルをワイルドカードで対象にするかを指定します。
  #   # 設定可能な値:
  #   #   - true: データベース配下のすべてのテーブルを対象
  #   #   - false (デフォルト): ワイルドカードを使用しない
  #   # 注意: nameとwildcardのどちらか一方が必須です。
  #   wildcard = false
  #
  #   # catalog_id (Optional)
  #   # 設定内容: テーブルが属するData Catalogの識別子を指定します。
  #   # 設定可能な値: 有効なAWSアカウントID（12桁の数字）
  #   # 省略時: 呼び出し元のアカウントIDが使用されます。
  #   catalog_id = null
  # }

  # table_with_columns (Optional)
  # 設定内容: LF-タグをアタッチするテーブルの列リソースの設定ブロックです。
  #           column_namesまたはwildcardのいずれか一方を指定してください。
  # table_with_columns {
  #
  #   # database_name (Required)
  #   # 設定内容: テーブルが属するデータベースの名前を指定します。
  #   # 設定可能な値: Data Catalog内で一意のデータベース名文字列
  #   database_name = "example_database"
  #
  #   # name (Required)
  #   # 設定内容: テーブルリソースの名前を指定します。
  #   # 設定可能な値: データベース内のテーブル名文字列
  #   name = "example_table"
  #
  #   # column_names (Optional)
  #   # 設定内容: 対象とするテーブルの列名のセットを指定します。
  #   # 設定可能な値: テーブル内の列名文字列のセット
  #   # 注意: column_namesとwildcardのどちらか一方が必須です。
  #   column_names = ["column1", "column2"]
  #
  #   # excluded_column_names (Optional)
  #   # 設定内容: テーブルから除外する列名のセットを指定します。
  #   # 設定可能な値: テーブル内の列名文字列のセット
  #   # 注意: excluded_column_namesを指定する場合、wildcardをtrueに設定する必要があります。
  #   excluded_column_names = ["sensitive_column"]
  #
  #   # wildcard (Optional)
  #   # 設定内容: テーブルのすべての列をワイルドカードで対象にするかを指定します。
  #   # 設定可能な値:
  #   #   - true: テーブルのすべての列を対象（excluded_column_namesと組み合わせ可能）
  #   #   - false: ワイルドカードを使用しない
  #   # 注意: column_namesとwildcardのどちらか一方が必須です。
  #   #        excluded_column_namesを使用する場合はtrueが必須です。
  #   wildcard = false
  #
  #   # catalog_id (Optional)
  #   # 設定内容: テーブルが属するData Catalogの識別子を指定します。
  #   # 設定可能な値: 有効なAWSアカウントID（12桁の数字）
  #   # 省略時: 呼び出し元のアカウントIDが使用されます。
  #   catalog_id = null
  # }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定する設定ブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "1h" 等のGo duration形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトが使用されます。
    create = null

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "1h" 等のGo duration形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトが使用されます。
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースのTerraform内部識別子
#---------------------------------------------------------------
